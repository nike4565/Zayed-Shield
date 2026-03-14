# Zayed Shield Security Keys

This file documents the cryptographic keys used to sign commits and releases.

## GPG Signing Key

Name: Al-Muharib 
Project: Zayed Shield Security
Email: nike494949@outlook.sa

Key ID:377E55582A0B8E19
Fingerprint:CAA7 C226 3216 EDF9 DAF1 8690 377E 5558 2A0B 8E19
Subkey:FCF6A81DF91CBE91
## Verification

To verify a signed commit:

```bash
git verify-commit <commit-id>
To verify a file signature:
gpg --verify file.sig file
Trust Model
All official commits and releases of Zayed Shield are signed using the above key.


