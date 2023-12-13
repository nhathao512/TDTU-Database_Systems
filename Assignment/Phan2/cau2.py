from itertools import chain, combinations

def find_closure(attributes, dependencies):
    closure = set(attributes)
    old_closure = set()
    while closure != old_closure:
        old_closure = set(closure)
        for dependency in dependencies:
            if set(dependency[0]).issubset(closure):
                closure.update(dependency[1])
    return sorted(list(closure))

def find_keys(attributes, dependencies):
    keys = []

    def is_superkey(subset):
        closure = find_closure(subset, dependencies)
        return set(attributes) == set(closure)

    for i in range(1, len(attributes) + 1):
        all_subsets = combinations(attributes, i)
        for subset in all_subsets:
            if is_superkey(subset):
                is_minimal = True
                for existing_key in keys:
                    if set(subset).issuperset(existing_key):
                        is_minimal = False
                        break
                if is_minimal:
                    keys.append(sorted(list(subset)))
    return keys

def powerset(iterable):
    s = list(iterable)  
    return list(chain.from_iterable(combinations(s, r) for r in range(1, len(s) + 1)))

def read_file(file_name):
    with open(file_name, 'r', encoding='utf-8') as file:
        lines = file.readlines()
        attributes = lines[0].split('=')[1].strip().replace('{', '').replace('}', '').replace(' ', '').split(',')
        dependencies = [tuple(dep.split('->')) for dep in lines[1].split('=')[1].strip().replace('{', '').replace('}', '').replace(' ', '').split(',')]
        X = set(lines[2].split('=')[1].strip().replace(' ', ''))
    return attributes, dependencies, X

def write_file(file_name, closure, keys, dependencies):
    with open(file_name, 'w', encoding='utf-8') as file:
        file.write(f'Bao Dong: {"".join(closure)}\n')
        keys_str = ', '.join(''.join(key) for key in keys)
        file.write(f'Cac Khoa: {keys_str}')

def main():
    attributes, dependencies, X = read_file('input2.txt')
    closure = find_closure(X, dependencies)
    keys = find_keys(attributes, dependencies)
    write_file('output2.txt', closure, keys, dependencies)

if __name__ == '__main__':
    main()