# 📚 Generate Docs From Commit History

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Generate%20Docs-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=github)](https://github.com/marketplace/actions/generate-docs-from-commit-history)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A GitHub Action that automatically generates structured documentation from pull request commit messages using GeminiAI. Perfect for maintaining changelogs, release notes, and documentation updates with minimal effort.

## 🌟 Features

- Automatically fetches commit messages from merged pull requests
- Generates structured, well-formatted documentation using GeminiAI
- Customizable prompts for different documentation styles
- Easy integration with existing GitHub workflows
- Docker-based for consistent execution environment

## 📋 Prerequisites

Before using this action, you'll need:

1. A GitHub Token (automatically provided by GitHub Actions)
2. A GeminiAI API key (get one from [Google AI Studio](https://makersuite.google.com/app/apikey))

## 🚀 Usage

Add the following workflow to your repository (e.g., `.github/workflows/generate-docs.yml`):

```yaml
name: Generate Documentation
on:
  pull_request:
    types: [closed]

jobs:
  generate-docs:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Generate Documentation
        uses: RndmCodeGuy20/doc-gen@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          genai_api_key: ${{ secrets.GENAI_API_KEY }}
          repo: ${{ github.repository }}
          pr_number: ${{ github.event.pull_request.number }}
```

## ⚙️ Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github_token` | GitHub token for API requests | Yes | N/A |
| `genai_api_key` | GeminiAI API key for generating release notes | Yes | N/A |
| `repo` | GitHub repository (owner/repo) | Yes | N/A |
| `pr_number` | Pull request number | Yes | N/A |
| `prompt` | Custom prompt for generating release notes | No | "Generate a structured release note from the following commit messages:" |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `release_notes` | Generated documentation from commit messages |

## 🔍 Example with Custom Prompt

```yaml
steps:
  - name: Generate Documentation
    uses: RndmCodeGuy20/doc-gen@v1
    with:
      github_token: ${{ secrets.GITHUB_TOKEN }}
      genai_api_key: ${{ secrets.GENAI_API_KEY }}
      repo: ${{ github.repository }}
      pr_number: ${{ github.event.pull_request.number }}
      prompt: "Create a detailed changelog entry with the following sections: Features, Bug Fixes, and Breaking Changes. Use the following commit messages:"
```

## 🔒 Security

- Never commit your GeminiAI API key directly in your workflows
- Store it as a GitHub Secret and reference it using `${{ secrets.GENAI_API_KEY }}`
- The default `GITHUB_TOKEN` has the necessary permissions for this action

## ⚡️ Advanced Usage

### Using the Generated Documentation

You can use the generated documentation in subsequent steps of your workflow:

```yaml
steps:
  - name: Generate Documentation
    id: generate_docs
    uses: RndmCodeGuy20/doc-gen@v1
    with:
      github_token: ${{ secrets.GITHUB_TOKEN }}
      genai_api_key: ${{ secrets.GENAI_API_KEY }}
      repo: ${{ github.repository }}
      pr_number: ${{ github.event.pull_request.number }}

  - name: Create Release
    uses: actions/create-release@v1
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    with:
      tag_name: ${{ github.ref }}
      release_name: Release ${{ github.ref }}
      body: ${{ steps.generate_docs.outputs.release_notes }}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Author

**Shantanu Mane (RndmCodeGuy20)**

## ❓ Support

If you encounter any problems or have questions:
1. Open an issue in the repository
2. Provide detailed information about your use case and the error you're seeing