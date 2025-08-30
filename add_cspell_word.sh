#!/bin/bash

SETTINGS_FILE=".vscode/settings.json"

# Create .vscode/settings.json if it doesn't exist
mkdir -p .vscode
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# Read the word from the user
read -p "Enter the word to add to cSpell.words: " new_word

# Use jq to update the JSON file safely
if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install jq first."
  exit 1
fi

# Check if cSpell.words array exists, create it if not
jq_exists=$(jq 'has("cSpell.words")' "$SETTINGS_FILE")
if [ "$jq_exists" = "false" ]; then
  # Add the cSpell.words array with the new word
  jq --arg word "$new_word" '. + {"cSpell.words": [$word]}' "$SETTINGS_FILE" > tmp.$$.json && mv tmp.$$.json "$SETTINGS_FILE"
  echo "Added $new_word to cSpell.words"
  exit 0
fi

# Check if the word already exists in the array
word_exists=$(jq --arg word "$new_word" '.["cSpell.words"] | index($word)' "$SETTINGS_FILE")

if [ "$word_exists" != "null" ]; then
  echo "The word '$new_word' already exists in cSpell.words."
  exit 0
fi

# Append the new word to the cSpell.words array
jq --arg word "$new_word" '.["cSpell.words"] += [$word]' "$SETTINGS_FILE" > tmp.$$.json && mv tmp.$$.json "$SETTINGS_FILE"
echo "Added $new_word to cSpell.words."
