# Contributing to the FCFS Rules Repository

## Purpose of this document
Welcome! This repository stores the official FreeSambo Combat Fighting System (FCFS) rules in many languages so coaches, referees, and organizers can rely on the same guidance everywhere. ✅ The English text in `/rules/en/FCFS.en.md` is the primary source. Every translation must match it exactly. The content is licensed under **Creative Commons BY-ND 4.0**, so all edits must be reviewed and merged through pull requests before they become official.

## Before you start
1. Create or sign in to your GitHub account. This lets the editors contact you and keeps a record of every change.
2. No coding skills are required. We work with plain text files.
3. You can edit files directly in your web browser by using the GitHub interface—no special software needed.

## How to propose a change
Follow these steps to suggest corrections or improvements:
1. Open the folder for your language (for example `/rules/en/FCFS.en.md` or `/rules/pl/FCFS.pl.md`).
2. Click the **Edit (✏️)** button on the top right of the file view to start editing in your browser.
3. Make the change and add a short note in the text box called “Description” explaining what changed and why (e.g., spelling fix, grammar correction, translation adjustment).
4. Scroll down and choose **Create pull request**. Give the pull request a clear title like `Fix typo in Polish rules` and click submit.

Every pull request is reviewed by official FCFS editors before it is merged. They check accuracy, alignment with the English source, and style. Approved changes become part of the official rules.

## How to contribute a new translation
Ready to add a new language? 📝 Follow these steps:
1. Use the English file as your template. You can copy `/rules/en/FCFS.en.md` or `/rules/en/FCFS.short.en.md`.
2. Place the new file inside a folder named after the language code (e.g., `/rules/de/`).
3. Name the file using this pattern: `FCFS.<lang>.md` for the full rules or `FCFS.short.<lang>.md` for the short version (example: `FCFS.de.md`).
4. Keep every section title, numbering, and article order identical to the English source. This makes updates easy to compare.
5. Use consistent terminology (for example “submission,” “hold,” “throw”). Avoid personal interpretations—translate meaning, not opinion.
6. Save the file and submit it through a pull request, just like in the previous section.

## Translation review and approval
FCFS editors compare new or updated translations against the English source. They check terminology, tone, and accuracy. Once your pull request is approved and merged, GitHub Actions automatically build the official packages in `.pdf`, `.html`, and `.docx` formats. This keeps every language release synchronized.

## Style and formatting tips
- Use plain Markdown: `#` for headings, `-` or `1.` for lists, and blank lines between paragraphs.
- Do **not** change the document structure or numbering.
- Keep official terms consistent. Here is an example glossary block:

```markdown
- submission
- hold
- throw
```

- Avoid machine translations. Human phrasing keeps the meaning clear.

## Need help?
Questions, clarifications, or translation support? Please open a GitHub Issue in this repository so the right editor can respond. For rare urgent cases, email us at [info@freesambo.com](mailto:info@freesambo.com), but GitHub keeps the discussion transparent for everyone. 💡

Thank you for helping share the FCFS rules worldwide!
