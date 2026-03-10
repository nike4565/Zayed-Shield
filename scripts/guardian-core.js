#!/usr/bin/env node

/**
 * Zayed Shield - Guardian Core
 * Professional project structure auditor and organizer helper
 *
 * وظيفته:
 * - يفحص المجلدات المهمة
 * - يبلغ عن الملفات المكررة أو الحساسة
 * - ينبه إلى المسارات الخاطئة
 * - لا يحذف شيئًا تلقائيًا
 */

const fs = require("fs");
const path = require("path");

const ROOT = process.cwd();

const REQUIRED_DIRS = [
  "docs",
  "scripts",
  "tests",
  ".github",
  ".github/workflows",
];

const SUSPICIOUS_PATHS = [
  ".github/workflows/.github",
  ".github/workflows/.github/workflows",
  "docs/.backups",
  ".backups",
  "node_modules",
];

const SENSITIVE_PATTERNS = [
  /\.pem$/i,
  /\.key$/i,
  /\.asc$/i,
  /\.ovpn$/i,
  /passwords?\.txt$/i,
  /client-cert/i,
  /server-cert/i,
  /private/i,
];

const IGNORE_DIRS = new Set([
  ".git",
  "node_modules",
  ".backups",
]);

function exists(relPath) {
  return fs.existsSync(path.join(ROOT, relPath));
}

function walk(dir, results = []) {
  const fullDir = path.join(ROOT, dir);
  if (!fs.existsSync(fullDir)) return results;

  for (const entry of fs.readdirSync(fullDir, { withFileTypes: true })) {
    const rel = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      if (IGNORE_DIRS.has(entry.name)) continue;
      walk(rel, results);
    } else {
      results.push(rel);
    }
  }

  return results;
}

function printSection(title) {
  console.log(`\n=== ${title} ===`);
}

function auditRequiredDirs() {
  printSection("Required directories");
  let ok = true;

  for (const dir of REQUIRED_DIRS) {
    if (exists(dir)) {
      console.log(`✔ ${dir}`);
    } else {
      console.log(`✖ Missing: ${dir}`);
      ok = false;
    }
  }

  return ok;
}

function auditSuspiciousPaths() {
  printSection("Suspicious paths");
  let found = false;

  for (const relPath of SUSPICIOUS_PATHS) {
    if (exists(relPath)) {
      console.log(`⚠ Found suspicious path: ${relPath}`);
      found = true;
    }
  }

  if (!found) {
    console.log("✔ No suspicious nested paths found");
  }
}

function auditSensitiveFiles() {
  printSection("Sensitive-looking files");
  const files = walk(".");
  const flagged = files.filter((file) =>
    SENSITIVE_PATTERNS.some((pattern) => pattern.test(path.basename(file)))
  );

  if (flagged.length === 0) {
    console.log("✔ No obviously sensitive file names found");
    return;
  }

  for (const file of flagged) {
    console.log(`⚠ Review file: ${file}`);
  }
}

function auditDuplicateWorkflowNesting() {
  printSection("Workflow nesting sanity check");
  const weirdWorkflowPath = ".github/workflows/.github/workflows";

  if (exists(weirdWorkflowPath)) {
    console.log(`✖ Invalid nested workflow directory found: ${weirdWorkflowPath}`);
    console.log("  Recommendation: move scripts to /scripts and keep only *.yml in .github/workflows");
  } else {
    console.log("✔ Workflow directory structure looks sane");
  }
}

function main() {
  console.log("Zayed Shield Guardian Core");
  console.log(`Project root: ${ROOT}`);

  auditRequiredDirs();
  auditSuspiciousPaths();
  auditSensitiveFiles();
  auditDuplicateWorkflowNesting();

  printSection("Recommendations");
  console.log("- Keep executable scripts in /scripts");
  console.log("- Keep only workflow YAML files in /.github/workflows");
  console.log("- Keep backups out of the repository");
  console.log("- Rename example secrets/configs with .example suffix");
  console.log("- Review sensitive-looking files before pushing");
}

main();
