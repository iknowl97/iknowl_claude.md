# Hooks — დეტერმინისტული Guardrails (Deterministic checks, not prompts)

ნებისმიერი კრიტიკული წესი, რომელიც "აუცილებლად ყოველთვის უნდა შესრულდეს" (მაგ. სენსიტიური მონაცემების დაბლოკვა, force-push-ის აკრძალვა), უნდა გაფორმდეს როგორც Hook და არა როგორც ტექსტური ინსტრუქცია `CLAUDE.md`-ში. ტექსტური წესები სრულდება ალბათურად; Hook-ები ეშვება გარანტირებულად. ჰუკი, რომელიც აბრუნებს `exit code 2`-ს, ბლოკავს მოქმედებას (Blocks action).

კონფიგურაცია გაწერილია `.claude/settings.json`-ში:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "node .claude/hooks/block-secrets.js"
      }
    ]
  }
}
```

### ხელმისაწვდომი სკრიპტები:
1. **`block-secrets.js`** — Universal Node.js Hook (მუშაობს ნებისმიერ OS-ზე: Windows, macOS, Linux გარე ბინარების გარეშე).
2. **`block-secrets.ps1`** — Native Windows PowerShell Hook.
3. **`block-secrets.sh`** — Native Unix / POSIX Bash Hook.
