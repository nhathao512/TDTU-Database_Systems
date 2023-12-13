def read_lines(file_name):
    with open(file_name, encoding='utf-8') as f:
        return f.readlines()
    
pkey_names = []
prikeys = []

def erd_entities(lines):
    tables = []
    for line in lines:
        if '-' not in line:

            parts = line.split(',')
            entity = parts[0].split(' ')[0]
            attrs = parts[0].split(' ')[1:]  
            pkeys = []      
            if len(parts) > 1:
                pkeys.append(parts[1].strip())
            else:
                pkeys.extend(attrs)  
            table = f"{entity} \n"          
            for attr in attrs:               
                if attr in pkeys:
                    table += f'{attr}\n'
                else:
                    table += f'{attr}\n'         
            if len(pkeys) > 1:
                refs = ' '.join(pkeys)
                table += f'PRIMARY KEY: {refs}' 
            else:
                table += f'PRIMARY KEY: {pkeys[0]}'   
             
            tables.append(table)
            prikeys.append(pkeys) 
            pkey_names.append(entity)
            
    return tables, prikeys, pkey_names

def erd_relationship(lines, prikeys, pkey_names):
    relationships = []
    for line in lines:
        if '-' in line:
            parts = line.strip().split(' ') 
            entities = parts[0]  
            rel = parts[1]
            if rel == "Inheritance":
                newtable = " "
            else:
                newtable = parts[2]
            ent1, ent2 = entities.split('-')

            if (rel == '1-1'):
                relationships.append(f'{entities}: RELATIONSHIP(1-1)')   
                pkey1 = prikeys[pkey_names.index(ent1)]
                fkey1 = prikeys[pkey_names.index(ent2)]              
                table = f'{newtable}'
                table += f'\nPRIMARY KEY: {pkey1[0]}'   
                table += f'\nFOREIGN KEY: {fkey1[0]}'     

                relationships.append(table)
            elif (rel == '1-N'):
                relationships.append(f'{entities}: RELATIONSHIP(1-N)')
                pkey1 = prikeys[pkey_names.index(ent1)]
                fkey1 = prikeys[pkey_names.index(ent2)]          
                table = f'{newtable}'
                table += f'\nPRIMARY KEY: {pkey1[0]}'   
                table += f'\nFOREIGN KEY: {fkey1[0]}'  

                relationships.append(table)
            elif (rel == 'N-N'):    
                relationships.append(f'{entities}: RELATIONSHIP({rel}) Create Entity: 'f'{newtable}')
                pkey1 = prikeys[pkey_names.index(ent1)]
                pkey2 = prikeys[pkey_names.index(ent2)]
                table = f'{newtable}'
                table += f'\nPRIMARY KEY: {", ".join(pkey1 + pkey2)}'
                table += f'\nFOREIGN KEY: {", ".join(pkey1 + pkey2)}'

                relationships.append(table)
            else:
                relationships.append(f'{entities}: RELATIONSHIP(Inheritance)')

    return relationships

def write_tables(tables, rels):
    with open('output1.txt','w', encoding='utf-8') as f:
       f.write('\n\n'.join(tables + rels))

def main():
    lines = read_lines('input1.txt')
    entities = [] 
    relationships = []
    for line in lines:
       if '-' not in line:
           entities.append(line)
       else:
           relationships.append(line)        
    tables, prikeys, pkey_names = erd_entities(entities)
    rels = erd_relationship(relationships, prikeys, pkey_names)  
    write_tables(tables, rels)
main()