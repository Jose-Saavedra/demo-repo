#Problem 2
names_columns <-  c('symboling',
                    'normalized_losses'
                    ,'make','fuel_type'
                    ,'aspiration',
                    'num_of_doors',
                    'body_style',
                    'drive_wheels',
                    'engine_location',
                    'wheel_base',
                    'length',
                    'width',
                    'height',
                    'curb_weight',
                    'engine_type',
                    'num-of_cylinders',
                    'engine_size',
                    'fuel_system',
                    'bore',
                    'stroke',
                    'compression_ratio',
                    'horsepower',
                    'peak_rpm',
                    'city_mpg',
                    'highway_mpg',
                    'price'
                    )
columns_types <- c('integer',
                   'real',
                   'character',
                   'character',
                   'character',
                   'character',
                   'character',
                   'character',
                   'character',
                   'real',
                   'real',
                   'real',
                   'real',
                   'integer',
                   'character',
                   'character',
                   'integer',
                   'character',
                   'real',
                   'real',
                   'real',
                   'integer',
                   'integer',
                   'integer',
                   'integer',
                   'integer'
                   )
autos <- read.csv(file = 'imports-85.data',
                  col.names = names_columns,
                  colClasses = columns_types,
                  na.strings = '?',
                  header = F)
str(autos)

library(readr)


autos2 <- read_csv(file = 'imports-85.data',
                   col_names = names_columns,
                   na='?',
                   col_types = list(
                   normalized_losses=col_double()
                   ))
str(autos2)
#Porblem 3

#a
auto3 <- read.csv(file = 'imports-85.data')
#the first row becomes the column names this is bad you can indecate not to have column names 

#b
auto3 <- read.csv(file = 'imports-85.data', header = F)
#the top code gives use all the data with not columns names (generic V# names)

#c
auto3 <- read.table(file = 'imports-85.data', sep = ',',header = F,na.strings = '?')
str(auto3)
#they become factors since the columns had at least one character, and a column of characters in dataframe are automatilly made
#as factors 

#d
object.size(auto3)
#37464bytes
auto3 <- read.table(file = 'imports-85.data',
                    sep = ',',
                    header = F,
                    colClasses = columns_types,
                    na.strings='?'
)
object.size(auto3)
#42328 bytes
#the reason the second is bigger is come from the difference in data types, mainly the fact that 

#e
autoM <- data.matrix(auto3,rownames.force = NA)
str(autoM)
#we get a matrix of real and where there were characters are now NA

#Problem 4
hist(autos$price, col = c('blue','red', 'green'),xlab = 'Price in Dollar',
     main = 'Histogram of Prices of Autos')

boxplot(autos$horsepower, horizontal = T, main='Box plot og horsepower')

barplot(sort(table(autos$body_style), decreasing = T), col = c('red','blue'))

stars(autos[autos$aspiration=='turbo',][,c(10:13,26)],main = 'stars plot of cars with turbo',key.loc = c(12,2))
?stars
#problem 5
mean(autos[autos$fuel_type =='gas',]$price, na.rm = TRUE)

mean(autos[autos$fuel_type=='diesel',]$price, na.rm = TRUE)


autos[autos$num.of_cylinders=='twelve',]$make

A <- aggregate(autos[,"make"], by=list(autos$make,autos$fuel_type),FUN = length)
A[which.max(A[A$Group.2=='diesel',]$x),]$Group.1


autos[which.max(autos$horsepower),]$price

Bottom10 <- range(autos$city_mpg, na.rm = T)
Bottom10[2] <- quantile(autos$city_mpg, probs = .1)
Bottom10

Top10<- range(autos$highway_mpg, na.rm = T)
Top10[1] <- quantile(autos$highway_mpg, probs = .9)
Top10


median(autos[autos$city_mpg<Bottom10[2],]$price,na.rm = T)


#Problem 6
#a
#dat$column_name allows us to call on the column of name: column_name and treating this as a vector
#dat$xyz if xyz does not exist then R returns NULL

#b

mtcars$mpg#good
mtcars[ ,1]#good
mtcars[[1]]#good
mtcars[ ,mpg]#bad
mtcars[["mpg"]]#good
mtcars$"mpg"#good
mtcars[ ,"mpg"]#good

is.vector(auto3[,1])
#c
#number 4 is worng since mpg itself is not a object with a value so R doesnt know what to do with it and fais

#d
# Yes one can add a list to a data frame since the a dataframe is a list and a list can be appended to a list

mtcars$NEWlist <- list(1,'five', T,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,NA,1,1,1,1,1,1,1,1,1,1)
mtcars <- mtcars[,-12]

#e
B <- as.list(mtcars)
str(B)
#a list of ll vectors numerical vectors

#f
C <- as.data.frame(B)
C
#we loose the row names of the cars


#Problem 7
library(corrplot)
qdat <- cor(na.omit(autos[,c(10:14, 17, 19:26)]))
#corrplot number 1
corrplot(qdat, method = 'circle')
#corrplot number 2
corrplot(qdat, method = 'color')

#problem 8
PCA_qdat <- prcomp(qdat, scale. = T)

# eigenvalues
eigenvalues <- PCA_qdat$sdev^2
eigenvalues
sum(eigenvalues)
barplot(eigenvalues/14)
#percent of variation captured by the first components 
sum(eigenvalues[1:3]/14)*100
PCA_qdat$x
PC <- as.data.frame(PCA_qdat$x)
loadings <- as.data.frame(PCA_qdat$rotation)
PC$PC1
plot(PC$PC1, PC$PC2,
     xlab = 'Principal Component 1',
     ylab = 'Principal Component 2', abline(h=0, v=0))

plot(loadings$PC1,loadings$PC2,
     xlab = 'Loading 1',
     ylab = 'Loading 2')
biplot(PCA_qdat, scale = 0)



PCA_autos <- prcomp(na.omit(autos[,c(10:14, 17, 19:26)]), scale. = T)
PC_1 <- PCA_autos$x
PC_1
plot(PC_1[,1],PC_1[,2],cex=1)

PC_loadings <- PCA_autos$rotation
PC_loadings
plot(PC_loadings[,1],PC_loadings[,2],pch=19,cex=.7,
     xlab = "PC #1 Loading",ylab = "PC #2 Loadin",
     xpd=T, xlim = c(-.5,.6))
text(PC_loadings[,1],PC_loadings[,2]+.03, labels = row.names(PC_loadings),cex = 1,xpd=T)
colnames(PCA_autos$x)
barplot(PCA_autos$sdev^2)
biplot(PCA_autos,scale = 0)

