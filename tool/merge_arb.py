"""Merge feature string additions into the ARB files and regenerate l10n.

Each file in l10n_additions/*.json looks like
  {"ar": {"key": "قيمة", "@key": {...}}, "en": {"key": "value", "@key": {...}}}
and is merged into lib/l10n/app_ar.arb and app_en.arb. Idempotent: a key
already present with the same value is skipped; a key present with a
different value aborts the merge.

  python tool/merge_arb.py
"""
import glob
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARB = {'ar': f'{ROOT}/lib/l10n/app_ar.arb', 'en': f'{ROOT}/lib/l10n/app_en.arb'}


def load(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def save(path, data):
    tmp = path + '.tmp'
    with open(tmp, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    os.replace(tmp, path)


def main():
    arbs = {k: load(p) for k, p in ARB.items()}
    errors = []
    for add_path in sorted(glob.glob(f'{ROOT}/l10n_additions/*.json')):
        add = load(add_path)
        name = os.path.basename(add_path)
        plain = {lang: {k for k in add.get(lang, {}) if not k.startswith('@')} for lang in ARB}
        if plain['ar'] != plain['en']:
            errors.append(f'{name}: ar/en keys differ: {sorted(plain["ar"] ^ plain["en"])}')
            continue
        for lang in ARB:
            for key, value in add.get(lang, {}).items():
                cur = arbs[lang]
                if key in cur and cur[key] != value:
                    if key.startswith('@'):
                        continue
                    errors.append(f'{name}: {lang}.{key} already defined with a different value')
                    continue
                cur[key] = value
    if errors:
        print('\n'.join(errors))
        sys.exit(1)
    for lang, path in ARB.items():
        save(path, arbs[lang])
    subprocess.run(['flutter', 'gen-l10n'], cwd=ROOT, shell=(os.name == 'nt'), check=True)
    print('merged', {k: len([x for x in v if not x.startswith('@')]) for k, v in arbs.items()})


if __name__ == '__main__':
    main()
