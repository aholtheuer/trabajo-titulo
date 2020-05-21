library(mice)

X_NA<-read.csv("..\\data_na.csv", header=FALSE, sep=",")
#summary(X_NA)

tempX <- mice(X_NA[,c(-1)],m=1,seed=123,maxit=500, method='cart')
complete_data <- complete(tempX,1)

write.table(complete_data, file = "data_imp1.csv", sep = ",", 
            row.names = FALSE, col.names = FALSE )
