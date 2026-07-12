import re, collections
from ete3 import Tree

# --- 1. leggi le liste tassonomiche dallo script R ---
src = open('results/boxplots_v2.R').read()
liste = {}
for n in ['primates','rodentia','carnivora','cetacea','chiroptera',
          'reptilia','amphibia','other_mammals']:
    m = re.search(rf'^{n} <- c\((.*?)\)\n', src, re.S | re.M)
    liste[n] = set(re.findall(r'"([^"]+)"', m.group(1)))

ordine = ['amphibia','reptilia','primates','rodentia','carnivora',
          'cetacea','chiroptera','other_mammals']

def gruppo(taxon):
    for n in ordine:
        if any(taxon.startswith(p) for p in liste[n]):
            return n
    return 'aves'

albero_base = 'tree/melatonin_tree_filtered.contree'

def prepara(rec, foreground):
    t = Tree(albero_base, format=1)
    taxa_prank = {l.strip()[1:] for l in
                  open(f'alignment_prank/{rec}_prank.best.fas') if l.startswith('>')}
    tenuti = [l.name for l in t.get_leaves() if l.name in taxa_prank]
    t.prune(tenuti, preserve_branch_length=True)

    comp = collections.Counter(gruppo(l.name) for l in t.get_leaves())
    n_fg = 0
    for leaf in t.get_leaves():
        if gruppo(leaf.name) == foreground:
            leaf.name += '{Foreground}'
            n_fg += 1

    out = f'hyphy/{rec}_tree_busted_v2.nwk'
    t.write(format=1, outfile=out)

    print(f"\n{rec}  (foreground: {foreground})")
    print(f"  taxa nell'albero potato : {len(tenuti)}")
    print(f"  marcati come foreground : {n_fg}")
    print(f"  background              : {len(tenuti)-n_fg}")
    print(f"  composizione: " + ', '.join(f'{k}={v}' for k,v in comp.most_common()))
    print(f"  scritto: {out}")
    return n_fg, len(tenuti)-n_fg

print("="*60)
prepara('MTNR1A', 'chiroptera')
prepara('MTNR1B', 'chiroptera')
print("\n" + "="*60)
print("MTNR1C: nessun foreground (vedi nota sotto)")
