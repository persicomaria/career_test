how to calculate e-sample statistics and e-distances by R pkg energy
arg1<-rbind(ds1,ds2,ds3,tst1,tst2,tst3)
dP<-dim(ds1)
dR<-dim(ds2)
dC<-dim(ds3)
dp<-dim(testsetP)
dr<-dim(testsetN)
dc<-dim(testsetC)
vecOfDim<-c(dP,dR,dC,dp,dr,dc)
vecOfDim
e<-as.matrix(edist(arg1, vecOfDim , method="disco" ))
#how to tune some classifiers with R package e1071
data(iris)
"my.predict.NB"<-function(object,newdata){
predict(object,newdata=newdata[,-5],type="class") 
### newdata[,-5] is data set without groups variable
###
###
}
tune(naiveBayes,Species ~ ., data = iris,predict.fun=my.predict.NB)
obj <- tune(svm, Species~., data = iris, ranges = list(gamma = 2^(-1:1), cost = 2^(2:4)))
plot(obj)
#how to tune some classifiers with R package caret
  fit <- train(
     iris[,-5], iris$Species, "nb",
     trControl = trainControl(method = "cv", number = 10))
#how to read R code inside packages
getS3method("predict","naiveBayes")
fix(predict)
#how to generate models with Hkda
library(ks)
# bandwidth for training data
cat("Computing bandwidth matrices ... \n")
print(system.time(
Htrain0 <- Hkda(x=train.pc, x.group=train.groups,
           bw="plugin", pilot="samse", pre="sphere")
           ))
#how to do PCA for each population
g0<-y.tmp$"groups"
y.p <- y[g0==1, ]
print(dim(y.p))
pc1 <- prcomp(y.p, center=F, scale=F,
          tol=sqrt(.Machine$double.eps))
summary(pc1)
round(pc1$rotation, 3)
biplot(pc1, cex=1, col=c(5,1))
y.r <- y[g0==0, ]
print(dim(y.r))
pc2 <- prcomp(y.r, center=FALSE, scale=F,
          tol=sqrt(.Machine$double.eps))
summary(pc2)
round(pc2$rotation, 3)
biplot(pc2, cex=1, col=c(7,1))
y.c <- y[g0==2, ]
print(dim(y.c))
pc3 <- prcomp(y.c, center=FALSE, scale=F,
          tol=sqrt(.Machine$double.eps))
summary(pc3)
round(pc3$rotation, 3)
biplot(pc3, cex=1, col=c(4,1))
#how to balance the different components of training set
#first define a feature space
DfG7f.df<-read.table("bothfeat.huge.txt.weighted",header=T,sep=" ")
xvarsD<-c("aro"  , "gravy" ,"cai", "pi" , "molwt" ,"len","cB" ,"fop")
xvarsH<-c("yORF1"  , "yORF2" ,"groups",   "response" )
xvarsG1<-c("gof","mess","coe","exp","apa")
xvarsG2<-c("mip","ess","coe","exp","apa")
#do some check
length(which(!is.nan(DfG7f.df$apa)))#19096
length(which(is.nan(DfG7f.df$apa)))
nao.MyFeatureSpace.df<-na.omit(withAPA[,c(xvarsH,xvarsG1)]);dim(nao.MyFeatureSpace.df)
nao.MyFeatureSpace.df<-na.omit(withAPA[,c(xvarsH,xvarsG2)]);dim(nao.MyFeatureSpace.df)#
myds<-nao.MyFeatureSpace.df
gr<- myds[,xvarsH[3:4]]
y <- scale(as.matrix(myds[,c(xvarsG1)]), center=FALSE)
y.tmp<-cbind(y,gr)
#min(y);max(y)
#dim(y)
train.vars<-y
train.groups<-y.tmp[,"groups"];length(train.groups)
train.response<-y.tmp[,"response"];length(train.response)
cat("sampling size limited to xx because of limited size of random featured without missing values ","\n")
cat("sampling can be sometime mandatory due to out of memory issue  ","\n")
sidP=sample(which(train.groups == 1),915, replace=F)
sidN=sample(which(train.groups == 0),915, replace=F)
sidC=sample(which(train.groups == 2),915, replace=F)
cat("sampled train.vars due to run out of memory issue....","\n")
train.vars=rbind(train.vars[sidP,],train.vars[sidN,],train.vars[sidC,])
train.groups <-c(train.groups[sidP],train.groups[sidN],train.groups[sidC])
#how to run cross-validation with compare.kda.cv in ks R package
library(ks)
fix(compare.kda.cv)
# this line has to be modified: return(compare(x.group, kda.cv.gr, by.group = by.group))
#list(H.mod,....)
#return(list(H.mod ,compare(x.group, kda.cv.gr, by.group = by.group)))
confMatRES=list()
confMatRES[[1]]<-compare.kda.cv(x = train.pc, x.group = train.groups, bw = "plugin",  pilot = "samse", pre= "sphere", trace = T, by.group=T)
#how to create Lookup tables or hash table storing Intervals and associated bin labels
Features<-features[,c(2,3,5,6,7,8,9,10)]
names(Features)[7]<-"molwt"  # consider to do something like if(grep('log.',nam)){nam<-sub('log.', '', nam, perl = TRUE)}
names(Features)[8]<-"length"
Features.cuts <- list(
    c.molwt = cut(Features[,"molwt"], breaks=all.breaks$b.molwt),
    c.length = cut(Features[,"length"], breaks=all.breaks$b.length),
    c.cai = cut(Features[,"cai"], breaks=exp(all.breaks$b.cai)),
    c.aromaticity = cut(Features[,"aromaticity"], breaks=(all.breaks$b.aro)^2),
    c.fop = cut(Features[,"fop"], breaks=all.breaks$b.fop),
    c.codonBias = cut(Features[,"codonBias"], breaks=all.breaks$b.cB),
    c.pi = cut(Features[,"pi"], breaks=all.breaks$b.pi),
    c.gravy = cut(Features[,"gravy"], breaks=all.breaks$b.gravy))
mydf = list()
envFeat= list()
myLookupF= list()
for(i in 1:length(names(Features)))
{
nam<-names(Features)[i]
var2<-paste("c",nam,sep=".")
cat("questa e la feat: ","\n",nam,"\n","questi sono i breaks: ","\n",var2,"\n")
keys = levels(Features.cuts[[var2]])
moreLetters<-paste(LETTERS, 1:length(LETTERS), sep=".")
values = c(letters,LETTERS,moreLetters)
values<-values[1:length(keys)]
cat("questi sono i values: ","\n",values,"\n")
mydf[[nam]] = data.frame (keys, values, stringsAsFactors=FALSE)
myLookupF[[nam]] = function (key) d [match (key, d [,1]), 2]
envFeat[[nam]] = new.env()
environment (myLookupF[[nam]]) = envFeat[[nam]]
envFeat[[nam]]$d = mydf[[nam]]
}
how to test lookUp table
#function (key)
#d[match(key, d[, 1]), 2]
#<environment: 0x20a8870>
#myLookupF[[7]]("(9.73,9.88]")
#[1] "o"
#> myLookupF[[1]]("(2.83,3.24]")
#[1] "a"
#> myLookupF[[1]]("(12.6,13]")
#[1] "y"
#envFeat[[8]]
#<environment: 0x20a8870>
#> as.list(envFeat[[8]])                                      
#$d
          #keys values
#1  (2.77,2.93]      a
#2  (2.93,3.08]      b
#3  (3.08,3.24]      c
how to calculate Kernel density estimate for kernel discriminant analysis for 1- to 3 dimensions
kfhat<-kda.kde(x=df[,c(6:8)], x.group=df$response, Hs=Hpi1, gridsize=500)
plot(kfhat, y=testSet.18May[,c(6:8)],y.groups=testSet.18May[,13], colors=c("orange","blue","grey"), drawpoints=T, ptcol=c("orange","blue","grey"),size=3)
#also with size=2
syntax for kda function (ks package)
