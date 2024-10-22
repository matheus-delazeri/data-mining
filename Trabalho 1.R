library(jsonlite)
library(tidyr)
library(dplyr)
library(arules)

json <- fromJSON('https://raw.githubusercontent.com/matheus-delazeri/data-mining/refs/heads/main/padaria_trab.json')

dataset <- json %>%
  # Define um ID incremental no lugar dos IDs fixos
  mutate(compra = row_number()) %>%
  # Separa os produtos em rows individuais
  unnest(produtos)
  # Remove o restante da string após o primeiro espaço em branco (para generalizar o produto)
  #mutate(produtos = sapply(produtos, function(x) strsplit(x, " ")[[1]][1]))

trans <- as(split(dataset$produtos, dataset$compra), "transactions")
inspect(trans)

rules <- apriori(trans, parameter = list(supp = 0.04, conf = 0.2, minlen=2))

inspect(rules)

subset = subset(rules, subset = (rhs %pin% 'Doce'))
inspect(subset)
