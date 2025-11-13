# How to run test benches

1. Navigate to directory containing the [module].v file AND the [module]_tb.v file
2. Run the following commands:
```bash
iverilog -g2012 -o [part].vvp [part].v [part]_tb.v
vvp [part].vvp
```

# Dealing with Git

## The Git Triangle
1. Fork from upstream and occasionally pull from upstream to fork to keep the fork up to date
2. Make a new branch on the fork then make commits on that new branch
3. Pull the fork's branch into the codebase using a pull request

## Design Notebook commit AND pull request titles format
Make multiple commits with slightly descriptive names and THEN if you know you're going to make the last commit, format it as follows:
```bash
docs(dn): [Name] MM/DD/YYYY
```




