"""Controleer lokale links en publicatiegrenzen in een gebouwde Jekyll-site."""
import argparse
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


class Page(HTMLParser):
    def __init__(self, source):
        super().__init__(convert_charrefs=True)
        self.links = []
        self.ids = set()
        self.feed(source)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if attrs.get('id'):
            self.ids.add(attrs['id'])
        for key in ('href', 'src'):
            if attrs.get(key):
                self.links.append(attrs[key])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('site', type=Path)
    parser.add_argument('--baseurl', default='')
    args = parser.parse_args()
    root = args.site.resolve()
    baseurl = '/' + args.baseurl.strip('/') if args.baseurl.strip('/') else ''
    pages = {p.resolve(): Page(p.read_text()) for p in root.rglob('*.html')}
    errors = []
    count = 0
    if not pages:
        errors.append('Geen HTML-pagina’s gevonden.')
    for source, page in pages.items():
        for link in page.links:
            url = urlsplit(link)
            if url.scheme or url.netloc:
                continue
            path = unquote(url.path)
            if path.startswith('/'):
                if baseurl and path != baseurl and not path.startswith(baseurl + '/'):
                    errors.append(f'{source.relative_to(root)}: ontbrekend projectpad in {link}')
                    continue
                target = root / path[len(baseurl):].lstrip('/')
            else:
                target = source.parent / path if path else source
            target = target.resolve()
            if not target.is_relative_to(root):
                errors.append(f'{source.relative_to(root)}: verwijzing buiten de site: {link}')
                continue
            if target.is_dir():
                target /= 'index.html'
            count += 1
            if not target.is_file():
                errors.append(f'{source.relative_to(root)}: ontbreekt {link}')
            elif url.fragment and target in pages and unquote(url.fragment) not in pages[target].ids:
                errors.append(f'{source.relative_to(root)}: ontbrekend anker in {link}')
    for private in ('cursuskit', 'voorbeeldmateriaal', 'AGENTS.md', 'flake.nix', 'flake.lock',
                    'zellij-layout.kdl', 'scripts', 'beweging/samenvatting.md'):
        if (root / private).exists():
            errors.append(f'Niet voor publicatie bedoeld bestand aanwezig: {private}')
    for error in errors:
        print(error)
    print(f'{len(pages)} pagina’s, {count} lokale verwijzingen, {len(errors)} problemen.')
    raise SystemExit(bool(errors))


if __name__ == '__main__':
    main()
