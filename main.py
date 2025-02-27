import os
from google import genai

commit_messages = os.getenv("COMMIT_MESSAGES", "").replace(";", "\n")
user_prompt = os.getenv("USER_PROMPT", "")

prompt = ""

if user_prompt:
    prompt = user_prompt
else:
    prompt = f"Generate a structured release note from the following commit messages:\n{commit_messages}"

# client = openai.Client(api_key=os.getenv("OPENAI_API_KEY"))
# models = ["gpt-4o-mini", "gpt-3.5-turbo"]

# release_notes = "Error: Unable to generate release notes."
# for model in models:
#     try:
#         response = client.chat.completions.create(
#             model=model,
#             messages=[
#                 {"role": "system", "content": "You are an AI that generates structured release notes from commit messages."},
#                 {"role": "user", "content": prompt}
#             ]
#         )
#         release_notes = response.choices[0].message.content
#         break
#     except openai.OpenAIError as e:
#         print(f"Error with {model}: {e}")

# print("Generated Release Notes:\n")
# print(release_notes)


client = genai.Client(api_key=os.getenv("GENAI_API_KEY"))

response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents=[
        "You are an AI that generates structured changelog from commit messages.",
        prompt,
        "You must follow th format:",
        "## Features",
        "- Feature 1",
        "- Feature 2",
        "## Bug Fixes",
        "- Bug fix 1",
        "- Bug fix 2",
        "## Improvements",
        "- Improvement 1",
        "- Improvement 2",
        "## Breaking Changes",
        "- Breaking change 1",
        "- Breaking change 2",
        "## Deprecations",
        "- Deprecation 1",
        "- Deprecation 2",
    ]
)

print(response.text)

# Save output to a file
with open("release_notes.md", "w") as f:
    f.write(response.text)
