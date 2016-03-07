html <- list.files("/home/ht/Desktop/git/hansthompson.github.io/opendata/landuse/html")

links <- gsub(".html", "", html)

href <- paste0("<h2> <a href='http://akdata.org/opendata/landuse/html/", gsub(" ", "%20", html),  "'>",
               links, "</a></h2>")


fileConn<-file("/home/ht/Desktop/git/hansthompson.github.io/opendata/landuse/community-councils.html")
writeLines(href, fileConn)
close(fileConn)
