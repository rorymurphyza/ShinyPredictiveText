getCurrentEnvironment <- function() {
    z = sapply(ls(), function(x) object.size(get(x)));
    temp = sum(z);
    temp;
}