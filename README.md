# iknowl Claude Starter Pack — კონფიგურაცია Vibe Coding-ისთვის (2026)

Drop-in ფაილების ნაკრები Claude Code-ისთვის და AI ასისტენტებისთვის, შექმნილი და მორგებული **iknowl**-ის მიერ, რომელიც აერთიანებს თანამედროვე საუკეთესო პრაქტიკებს: ანდრეი კარპატის (Andrej Karpathy) ქცევით წესებს, ბორის ჩერნის (Boris Cherny, Claude Code-ის ხელმძღვანელი Anthropic-ში) Loop Engineering-ს, სუბაგენტების ვერტიკალურ იერარქიას დამოუკიდებელი შემმოწმებლებით (Independent Verifiers), ბაიესის ალბათობებზე დაფუძნებულ გადაწყვეტილებების მიღების მექანიზმს (Bayesian Decision Layer), პროექტის ნაკადურ მეხსიერებას (Stream Memory), დეტერმინისტულ Hook Guardrails-ს და თვითგანვითარებად მეტა-სწავლებას (Self-Evaluation / Continuous Learning via `/distill`).

> **ენობრივი კონვენცია (Bilingual Standard):**
> ყველა სისტემური წესი და პრომპტი შიგნით არის ინგლისურ ენაზე (რადგან LLM მოდელები ინგლისურ ინსტრუქციებს ყველაზე ზუსტად მიჰყვებიან). კომუნიკაცია, ამოცანების ახსნა, დოკუმენტაცია და აღწერები წარმოებს **ქართულ ენაზე**, ხოლო ტექნიკური ტერმინები, კოდი, ცვლადები და API-ები რჩება **ინგლისურად**.

---

## მთავარი პრინციპი (Core Principle)

ეს არის **სისტემური პაკეტი (Package)** და არა ერთი გიგანტური მონოლითური ფაილი. ძირითადი `CLAUDE.md` რჩება მცირე ზომის (< 100 ხაზი — მოდელები საუკეთესოდ მიჰყვებიან კომპაქტურ ინსტრუქციებს). ყველა სპეციფიკური და სიტუაციური წესი გატანილია ცალკეულ ფაილებში და იტვირთება ზარმაცად (Lazy Loading).

მენტალური მოდელი: **CLAUDE.md არის ოპერატიული მეხსიერება (RAM), ხოლო სუბაგენტები, წესები, ჰუკები და docs არის მყარი დისკი (Disk).**

---

## რა შედის პაკეტში (Package Structure)

```
iknowl-claude-pack/
├── README.md                       # ეს ფაილი (GE/EN დოკუმენტაცია)
├── CLAUDE.md                       # კონფიგის ბირთვი (Self-Organizing Bootstrap + OS detection)
├── AGENTS.md                       # Cross-tool სტანდარტი (Cursor, Antigravity, Codex, Windsurf)
├── setup.ps1                       # Windows PowerShell 1-Click Installer & OS Selector
├── setup.sh                        # Linux / macOS Bash 1-Click Installer & OS Selector
├── .gitignore                      # სუფთა Git ignore (OS, .env, temp files)
├── .claude/
│   ├── settings.json               # ოფიციალური Claude Code კონფიგურაცია და Hooks გააქტიურება
│   ├── mcp.json                    # Model Context Protocol (MCP) სერვერების შაბლონი
│   ├── commands/                   # Custom Slash Commands (8 ბრძანება)
│   │   ├── bootstrap.md            #   /bootstrap — Stack & OS Detection + CLAUDE.md Smart Migration
│   │   ├── plan.md                 #   /plan — ბინარული გეგმის შედგენა (Architect)
│   │   ├── verify.md               #   /verify — დამოუკიდებელი ტესტირება (Dual Verifiers)
│   │   ├── review.md               #   /review — Code Reviewer (Clean code & complexity check)
│   │   ├── audit.md                #   /audit — Security Auditor (Secrets, vulnerabilities & CVEs)
│   │   ├── learn.md                #   /learn — ხარვეზის სწრაფი ლოგირება LEARNINGS.md-ში
│   │   ├── distill.md              #   /distill — Self-Evaluation & წესების ავტო-პრომოუშენი
│   │   └── decide.md               #   /decide — ბაიესის EV გადაწყვეტილების მიღება
│   ├── agents/                     # ვერტიკალის 8 სუბაგენტი
│   │   ├── architect.md            #   არქიტექტორი: Goal -> Specs (კოდს არ წერს)
│   │   ├── implementer.md          #   დეველოპერი: ახორციელებს ერთ კონკრეტულ Spec-ს
│   │   ├── verifier-spec.md        #   ვერიფიკატორი #1: მექანიკური შემოწმება Spec-ის მიხედვით
│   │   ├── verifier-adversarial.md #   ვერიფიკატორი #2: დამოუკიდებელი კრიტიკოსი / Edge Cases
│   │   ├── fixer.md                #   მომწესრიგებელი: ასწორებს მხოლოდ ვერიფიკატორების მიერ ნაპოვნ ხარვეზებს
│   │   ├── risk-assessor.md        #   ბაიესის Pre-Mortem შეფასება რისკიანი გადაწყვეტილებების წინ
│   │   ├── security-auditor.md     #   უსაფრთხოების აუდიტორი: Secret Leaks, Injections, Auth Guards
│   │   └── code-reviewer.md        #   კოდის ექსპერტ-რივიუერი: Simplicity, Performance, Clean Code
│   ├── rules/
│   │   ├── platform.md             #   Cross-Platform წესები (Windows pwsh vs Linux bash/posix)
│   │   ├── karpathy.md             #   ქცევითი წესები (Think Before Coding, Simplicity First)
│   │   ├── bayes.md                #   გადაწყვეტილების მიღების ლოგიკა Likelihood Ratio-ზე
│   │   └── forbidden.md            #   კონკრეტული რეპოზიტორიის ანტი-პატერნები (Forbidden Anti-patterns)
│   └── hooks/
│       ├── README.md               #   რატომ არის Hooks > Text Instructions
│       ├── block-secrets.js        #   Universal Cross-Platform Node.js Secret Blocker Hook
│       ├── block-secrets.ps1       #   Windows PowerShell Secret Blocker Hook
│       ├── block-secrets.sh        #   Unix / POSIX Bash Secret Blocker Hook
│       ├── git-pre-commit.ps1      #   Git Pre-commit Hook (PowerShell)
│       └── git-pre-commit.sh       #   Git Pre-commit Hook (POSIX Bash)
└── docs/stream/
    ├── STATE.md                    # პროექტის მიმდინარე აქტუალური მდგომარეობა (Single Source of Truth)
    ├── DECISIONS.md                # მიღებული გადაწყვეტილებების ჟურნალი (ADR-lite)
    ├── LEARNINGS.md                # დაჭერილი შეცდომები -> მუდმივი წესები
    └── CHANGES/                    # Append-only ლოგი, თითო ფაილი თითო სესიაზე
        └── 2026-08-15-example.md
```

---

## ძირითადი შესაძლებლობები (Core Capabilities)

### 1. თვითორგანიზებადი CLAUDE.md & Smart Migration (`/bootstrap`)
თუ პროექტში უკვე არსებობდა ძველი `CLAUDE.md`, სისტემა არ წაშლის მას:
- ქმნის ავტომატურ სარეზერვო ასლს `docs/stream/CLAUDE.md.bak`-ში.
- ამოკრებს არსებული პროექტის ბრძანებებსა და წესებს და სვამს `## Project Specifics`-ში.
- ვრცელ წესებს გადაიტანს `.claude/rules/project-rules.md`-ში (LLM Context Window-ის დასაზოგად).
- აშორებს საწყის დირექტივას და ფაილს აყენებს იდეალურ <100 ხაზიან ფორმატში.

### 2. Windows & Linux/macOS სრული თავსებადობა (Cross-Platform)
- **ავტომატური OS დეტექცია:** `.claude/rules/platform.md` უზრუნველყოფს, რომ აგენტმა Windows-ზე გამოიყენოს PowerShell (`pwsh`) და სწორი Escape/Path სინტაქსი, ხოლო Linux/macOS-ზე POSIX ბრძანებები.
- **1-Click Installers:** `setup.ps1` (Windows) და `setup.sh` (Linux/macOS) მომენტალურად აყენებს და აკონფიგურირებს შესაბამის ჰუკებს.

### 3. ქართულ-ინგლისური მიქსის მხარდაჭერა (Bilingual Workflow)
- **აღწერები და კომუნიკაცია:** ახსნა-განმარტებები, ნაბიჯების დაგეგმვა, Commit Rationale, Status Update და კომენტარები იწერება **ქართულად**.
- **კოდი და ტექნიკური ტერმინები:** ცვლადების, ფუნქციების, კლასების სახელები, API მარშრუტები, SQL სქემები და დამკვიდრებული ტექნიკური ტერმინები (როგორიცაა *middleware, payload, endpoint, hook, state, database, schema, single-flight*) რჩება **ინგლისურად**.
- **UTF-8 Encoding:** უზრუნველყოფილია ქართული უნიკოდ-სიმბოლოების დაუზიანებლად შენახვა.

### 4. LOOP რეჟიმი და Verifier სუბაგენტები (`/verify`)
აგენტი არ მუშაობს პრინციპით "კითხვა-პასუხი". ყოველი ამოცანა იწყება ბინარულად შემოწმებადი მიზნით. შემმოწმებლები არიან ცალკე სუბაგენტები სუფთა კონტექსტით და Read-Only უფლებებით.

### 5. Self-Evaluation & თვითგანვითარებადი მეხსიერება (`/distill`)
სესიის ბოლოს გაშვებული `/distill` ბრძანება ამოწმებს `docs/stream/LEARNINGS.md`-ს: თუ რომელიმე ტიპის ხარვეზი განმეორდა 2-ჯერ ან მეტჯერ, სისტემა მას ავტომატურად აფორმებს როგორც მუდმივ წესს და ამატებს `.claude/rules/forbidden.md`-ში.

### 6. დეტერმინისტული Guardrails (Hooks)
`.claude/settings.json`-ში გაწერილია `PreToolUse` ჰუკები, რომლებიც ფიზიკურად ბლოკავს API Key-ების, პაროლების და სენსიტიური `.env` ფაილების კოდში შემთხვევით ჩაწერას (`exit code 2`). დამატებულია Git-ის დონის `git-pre-commit` ჰუკები.

---

## Custom Slash Commands

* **/bootstrap** — OS & Stack ავტო-დეტექცია, CLAUDE.md Smart Migration და `STATE.md`-ის ინიციალიზაცია.
* **/plan** — ამოცანის ქირურგიული დაგეგმვა და ბინარული Acceptance Criteria-ს განსაზღვრა.
* **/verify** — დამოუკიდებელი Verifier-ების გაშვება და რეალური Shell ტესტების ჩატარება.
* **/review** — კოდის ექსპერტული რევიუ (Clean Code, არქიტექტურა, Karpathy-ს პრინციპები).
* **/audit** — უსაფრთხოების, Secret Leaks-ის და დამოკიდებულებების (Dependencies) სრული სკანირება.
* **/learn** — დაჭერილი ხარვეზის და მუდმივი წესის სწრაფი ჩაწერა `LEARNINGS.md`-ში.
* **/distill** — Self-Evaluation: განმეორებადი შეცდომების წესების ბაზაში გადატანა.
* **/decide** — ბაიესის ალბათობების და EV (Expected Value) ცხრილის გათვლა რისკიან ნაბიჯებზე.

---

## სწრაფი დაწყება (Quick Start)

### ახალ ან არსებულ პროექტში ჩატვირთვა:

- **Windows (PowerShell):**
  ```powershell
  # გაუშვით პროექტის დირექტორიაში:
  .\setup.ps1
  ```

- **Linux / macOS (Bash):**
  ```bash
  # გაუშვით პროექტის დირექტორიაში:
  chmod +x setup.sh && ./setup.sh
  ```

### მუშაობის პროცესი:
1. გახსენით პროექტი Claude Code-ით (`claude`).
2. გაუშვით `/bootstrap` (სისტემა თავად მოარგებს ყველაფერს პროექტს).
3. დაგეგმეთ და შეასრულეთ ამოცანა: `/plan` -> განხორციელება -> `/verify`.
4. სესიის ბოლოს: `/distill` სისტემის თვითგანვითარებისთვის.
