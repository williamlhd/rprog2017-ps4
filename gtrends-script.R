library(gtrendsR)
library(ggplot2)
library(tidyverse)


bitcoin.trend <- gtrends(c("bitcoin"), gprop = "web", time = "all")[[1]]
class(bitcoin.trend)
head(bitcoin.trend)

class(bitcoin.trend$date)

ggplot(data = bitcoin.trend) + geom_line(mapping = aes(x= date, y = hits))
?gtrends

bitcoin.trend <- bitcoin.trend %>% filter(date >= as.Date("2009-01-01"))
ggplot(data = bitcoin.trend) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red") #trump inauguration
  

library(Quandl)
bitcoin.price <- Quandl("BCHARTS/BITSTAMPUSD")
bitcoin.price <- bitcoin.price %>% filter(Date %in% bitcoin.trend$date) %>% select(Date, Close) %>% rename(date = Date, price = Close) %>% mutate(price = price*100/max(price))

bitcoin <- left_join(x = bitcoin.trend, y= bitcoin.price, by = "date")
head(bitcoin)

ggplot(data = bitcoin) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_line(mapping = aes(x= date, y = price), color = "gray") + 
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red")

