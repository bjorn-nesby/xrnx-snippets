
arr = {
  {0,'On ch=1 n=48 v=127'},
  {48,'Off ch=1 n=48 v=0'},
  {48,'On ch=1 n=50 v=127'},
  {96,'Off ch=1 n=50 v=0'},
  {96,'On ch=1 n=52 v=127'},
  {144,'Off ch=1 n=52 v=0'},
  {144,'On ch=1 n=53 v=127'},
  {192,'Off ch=1 n=53 v=0'},
  {192,'On ch=1 n=55 v=127'},
  {240,'Off ch=1 n=55 v=0'},
  {240,'On ch=1 n=57 v=127'},
  {288,'Off ch=1 n=57 v=0'},
  {288,'On ch=1 n=59 v=127'},
  {336,'Off ch=1 n=59 v=0'},
  {336,'On ch=1 n=60 v=127'},
  {384,'Off ch=1 n=60 v=0'},
  {0,'On ch=1 n=52 v=127'},
  {48,'Off ch=1 n=52 v=0'},
  {48,'On ch=1 n=53 v=127'},
  {96,'Off ch=1 n=53 v=0'},
  {96,'On ch=1 n=55 v=127'},
  {144,'Off ch=1 n=55 v=0'},
  {144,'On ch=1 n=57 v=127'},
  {192,'Off ch=1 n=57 v=0'},
  {192,'On ch=1 n=59 v=127'},
  {240,'Off ch=1 n=59 v=0'},
  {240,'On ch=1 n=60 v=127'},
  {288,'Off ch=1 n=60 v=0'},
  {288,'On ch=1 n=62 v=127'},
  {336,'Off ch=1 n=62 v=0'},
  {336,'On ch=1 n=64 v=127'},
  {384,'Off ch=1 n=64 v=0'},
}


local compare = function(a, b)
  if (a and a[1] == b[1]) then
    return a[2] < b[2]
  else
    return a[1] < b[1]
  end
end

table.sort(arr,compare)
rprint(arr)

arr2 = { "apple2", "apple2", "apple02" }
rprint(arr2)
table.sort(arr2)
rprint(arr2)

