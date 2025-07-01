#!/bin/bash
set -e
echo "Generating changelog for version $1..."
cat << EOF > changelog.md
# Changelog for version $1

- Feature A was implemented.
- Bug B was fixed.
- Performance was improved.
EOF
echo "Changelog generated: changelog.md"
