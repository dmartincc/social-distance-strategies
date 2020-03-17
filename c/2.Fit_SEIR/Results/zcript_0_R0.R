a = read.table("result.txt")

R0 = c()
for(run in 1:100){
	b = a[a[,5]==run,3]+a[a[,5]==run,4]
	if(length(b)>60){

		b = data.frame(t=c(1:length(b)),I=b)

		b = b[30:60,]

		fit = lm(log(I)~t,data=b)

		R0 = c(R0,1+7.5*fit$coefficients[2])
	}
}
plot(hist(R0))
