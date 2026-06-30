#!/usr/bin/env node
// validate-examples.mjs — executable fixtures for the authentic-writing engine.
//
// For every examples/<case>/ with an expect.json oracle, run before.md and
// after.md through the REAL engine validators (PIPELINES + runValidators, via
// the engine's deterministic output) and assert:
//   - before.md trips every check listed in expect.json.expectBefore
//   - after.md has zero blocking violations and none of those checks
//
// The engine is a Workflow script (no imports/exports beyond `meta`), so we
// execute it with stubbed injected globals — the same harness technique used in
// the skill's verification. Single source of truth: the real engine code.
//
// Usage: node scripts/validate-examples.mjs   (exit 0 = all pass)

import { readFileSync, readdirSync, existsSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'

const HERE = dirname(fileURLToPath(import.meta.url))
const SKILL_DIR = dirname(HERE)
const ENGINE = join(SKILL_DIR, 'authentic-writing.js')
const EXAMPLES = join(SKILL_DIR, 'examples')

const engineSrc = readFileSync(ENGINE, 'utf8').replace('export const meta', 'const meta')

// Run the real engine with stubbed agents; return its workflow result object.
async function runEngine(format, text) {
  const phase = () => {}
  const log = () => {}
  const agent = async (prompt) => {
    if (prompt.includes('GRILL-ME JUDGE')) return { verdict: 'pass', riskLevel: 'low', grillQuestions: [], blockingReasons: [], summary: 'ok' }
    if (prompt.includes('YOUR LENS')) return { reviewer: 'x', readability: 5, clarity: 5, accuracy: 5, authenticity: 5, issues: [], summary: 'ok' }
    if (prompt.includes('finalizer')) return { path: 'out', deliverable: text, report: { scores: 'all 5', unresolvedGrillQuestions: [], notes: '' } }
    return text // draft / shape / revise all echo the fixture text
  }
  const parallel = (thunks) => Promise.all(thunks.map((t) => t()))
  const args = { format, brief: 'fixture', domain: 'fixture domain' }
  const body = `return (async () => { ${engineSrc} })()`
  // eslint-disable-next-line no-new-func
  const fn = new Function('phase', 'log', 'agent', 'parallel', 'args', body)
  return fn(phase, log, agent, parallel, args)
}

const checksOf = (result, severityArrays) =>
  severityArrays.flatMap((k) => (result[k] || []).map((v) => v.check))

function listCases() {
  if (!existsSync(EXAMPLES)) return []
  return readdirSync(EXAMPLES, { withFileTypes: true })
    .filter((d) => d.isDirectory() && existsSync(join(EXAMPLES, d.name, 'expect.json')))
    .map((d) => d.name)
    .sort()
}

let failures = 0
let passes = 0

for (const name of listCases()) {
  const dir = join(EXAMPLES, name)
  const oracle = JSON.parse(readFileSync(join(dir, 'expect.json'), 'utf8'))
  const format = oracle.format
  const expectBefore = oracle.expectBefore || []
  const beforeText = readFileSync(join(dir, 'before.md'), 'utf8')
  const afterText = readFileSync(join(dir, 'after.md'), 'utf8')

  const problems = []

  const before = await runEngine(format, beforeText)
  const beforeChecks = checksOf(before, ['blockingViolations', 'warnings'])
  for (const c of expectBefore) {
    if (!beforeChecks.includes(c)) problems.push(`before.md should trip "${c}" but did not (got: [${beforeChecks.join(', ') || 'none'}])`)
  }
  if (before.format !== format) problems.push(`before.md routed to "${before.format}", expected "${format}"`)

  const after = await runEngine(format, afterText)
  const afterBlocking = (after.blockingViolations || []).map((v) => v.check)
  const afterChecks = checksOf(after, ['blockingViolations', 'warnings'])
  if (oracle.expectAfterClean !== false && afterBlocking.length) {
    problems.push(`after.md should be free of blocking violations but had: [${afterBlocking.join(', ')}]`)
  }
  for (const c of expectBefore) {
    if (afterChecks.includes(c)) problems.push(`after.md should have fixed "${c}" but it still fires`)
  }

  if (problems.length) {
    failures++
    console.log(`✗ FAIL  ${name} (${format})`)
    for (const p of problems) console.log(`        - ${p}`)
  } else {
    passes++
    console.log(`✓ PASS  ${name} (${format})  before=[${expectBefore.join(', ')}] -> after clean`)
  }
}

console.log(`\n${passes} passed, ${failures} failed, ${passes + failures} cases.`)
process.exit(failures ? 1 : 0)
