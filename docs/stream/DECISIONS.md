# DECISIONS — გადაწყვეტილებების ჟურნალი (ADR-lite)

თითო ჩანაწერი თითო არატრივიალურ გადაწყვეტილებაზე. მიუთითეთ EV (Expected Value) ცხრილი risk-assessor-ის გაშვებიდან, როდესაც გამოყენებულია `.claude/rules/bayes.md` პროცედურა.

## Example
- D-07 [2026-08-15] არჩეულ იქნა Approach B (queue) Approach A-ს (webhooks) ნაცვლად.
  EV table: იხ. risk-assessor run 2026-08-15. Runner-up: A. გადაიხედოს თუ დატვირთვა გადააჭარბებს >1k rps-ს.
- D-08 [2026-08-18] დანერგილ იქნა Self-Organizing Bootstrap Directive Header და Cross-Platform Installers (setup.ps1 / setup.sh).
  Rationale: უზრუნველყოფს არსებული CLAUDE.md-ის არა-დესტრუქციულ მიგრაციას და სრულ Windows/Linux თავსებადობას.
