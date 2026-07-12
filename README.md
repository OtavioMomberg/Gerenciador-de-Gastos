### Gerenciador de Gastos

## Visão Geral:

- O projeto tem como objetivo auxiliar para um melhor controle a respeito dos gastos realizados pelo usuário

## Funcionalidades:

1. Criar 'Grupos'
2. Remover um Grupo
3. Atualizar nome de um Grupo
4. Adicionar novo gasto a um Grupo
5. Atualizar um gasto de um Grupo
6. Remover um gasto de um Grupo
7. Buscar por Grupos e gastos especifícos em cada Grupo
8. Calcular o valor total dos gastos em cada Grupo

## Stack do projeto:

# Database - (SQLite):

- groups_table:
    - id - int
    - name - text
    - card_color - text

- expanses:
    - id - int
    - name - text
    - price - double
    - payment_method - text
    - date - text
    - group_id - int (Foreign Key)

# Dart/Flutter:

- A aplicação será desenvolvida utilizando Dart/Flutter

# Design:

- O design será minimalista, com cores claras focadas no branco

# Navigation:

- A navegação entre telas será desenvolvida de forma tradicional com Navigation.push()

# Pages:

1. HomePage - A tela conterá botões para criar grupos, inserir novos gastos, calcular os gastos, visualizar os grupos e um campo para pesquisa

2. CreateGroupPage - A tela conterá campos para a criação de um grupo

3. GroupPage - A tela mostrará todos os gastos contidos no grupo selecionado

4. CreateItemPage - A tela conterá campos para a criação de um item (Gasto)

5. ItemPage - A tela mostrará um custo de forma detalhada, permitindo atualizar dados ou remover o item 