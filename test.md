第一題 - 3n+1問題

Description:

考慮以下的演算法：
1.輸入 n
2.印出 n
3.如果 n = 1 結束
4.如果 n 是奇數 那麼 n=3*n+1
5.否則 n=n/2
6.GOTO 2

例如輸入 22, 得到的數列： 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1
據推測此演算法對任何整數而言會終止 (當列印出 1 的時候)。雖然此演算法很簡單，但以上的推測是否真實卻無法知道。然而對所有的n ( 0 < n < 1,000,000 )來說，以上的推測已經被驗證是正確的。
給一個輸入 n ,透過以上的演算法我們可以得到一個數列（1作為結尾）。此數列的長度稱為n的cycle-length。上面提到的例子, 22 的 cycle length為 16.
問題來了：對任2個整數i，j我們想要知道介於i，j（包含i，j）之間的數所產生的數列中最大的 cycle length 是多少。

Input Description
輸入一筆測試資料i、j

0< i，j < 1,000,000

若 i > j，使用指標做交換

Output Description
你要輸出 i, j 和介於 i, j 之間的數所產生的數列中最大的 cycle length。

Input Samples
1 10

Output Sample
1 10 20

第二題 - 轉置矩陣

Description
已知一(m x n)矩陣A，我們常常需要用到另一個將A中之行與列調換的矩陣。這個動作叫做轉置矩陣。舉例來說，若

A:
3 1 2
8 5 4
則

AT:
3 8
1 5
2 4
現在請您針對所讀取到的矩陣進行翻轉。
https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fblog.csdn.net%2Fu013066730%2Farticle%2Fdetails%2F100518745&ved=0CBYQjRxqFwoTCNDr2oubsJQDFQAAAAAdAAAAABAG&opi=89978449

Input Description
第一行會有兩個數字，分別為 列(row)<100 和 行(column)<100，緊接著就是這個矩陣的內容

Output Description
直接輸出翻轉後的矩陣
Sample1
Input Sample
3 3
1 2 3
4 5 6
7 8 9

Output Sample
1 4 7
2 5 8
3 6 9

Sample2
Input Sample
2 3
3 1 2
8 5 4

Output Sample
3 8
1 5
2 4

第三題 - 學生成績排名

Description
今天是資電一甲的期中考，導師想撰寫一個程式來查看該班的總分排名，班上共有 N 名學生，每位學生有 3 門課（計算機概論、微積分、邏輯設計）。

請幫導師撰寫一個可以讀 N X 3 二維陣列之後去計算每位學生的總分，最後輸出由氣泡排序大到小排序後的成績單（排名 學生編號 總分）。



Input Description
第一行：一個整數N (1≤N≤60)。

第二行：使用 N X 3 二維陣列儲存成績

Output Description
第一行：讓程式輸出這一欄（排名 學生編號總分）
第二行之後：按照排名輸出結果

輸出格式：

排名 學生編號 總分

1    1    251



數字中間有 4 個空白做間隔

請勿使用 \t 會無法判定 AC

Sample1
Input Sample
3
86 75 90
79 66 73
77 83 65

Output Sample
排名 學生編號 總分
1    1    251
2    3    225
3    2    218

Hint
使用氣泡排序法做總分排序
＊對總分做排序之後，因為有變動順序，請一起將學生編號做交換＊

＊＊交換不強制使用指標＊＊