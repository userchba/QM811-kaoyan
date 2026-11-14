\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{style}[shui 自定义文档模板]

%基本设置

\LoadClass[UTF8,a4paper,
fontset=fandol,
openright,zihao=5]{ctexbook}
%其中winfonts解决某些不常用字无法正确显示的问题，其中openright与twoside的效果一样
%Linux下默认使用的字体有些生僻字无法正常显示

\RequirePackage[top=2.6cm,bottom=2.6cm,left=2.8cm,right=2.5cm]{geometry}
%页边距 其中的marginparsep(页边注与正文的间隔)是为了todonotes宏包的注释距离而重新设定,marginparwidth页注的宽度

\RequirePackage{xcolor}%定义了一些颜色

%超链接
\RequirePackage[draft=false,colorlinks=true,CJKbookmarks=true,linkcolor=black,citecolor=green,urlcolor=red,hyperindex,hypertexnames=false]{hyperref}

\RequirePackage{enumerate} %列项序号编号
\RequirePackage{amssymb} %数学公式符号
\RequirePackage{amsmath} %数学公式
\RequirePackage{mathtools} %数学公式扩展宏包,提供了公式编号定制和更多的符号、矩阵等。
\RequirePackage{amsfonts} %用来输入各种符号的特殊形态，例如字母的花体、空心体等，配合amssymb使用
\RequirePackage{mathrsfs} %数学中的花体(不是太花的)
\RequirePackage{graphicx} %图片


\usepackage{bm}%粗斜体，印刷向量的时候用，使用\bm{}
\usepackage{esvect}%矢量加箭头，使用  \vec{a} 或者 \vv{a}
\usepackage{svg}

% ctex 采用 zihao=5（10.53937pt）等非标准字号，而 rsfs / esvect 的 .fd 只
% 定义了 10、10.95 等标准尺寸，编译时会触发 "size ... substituted" 警告。
% 这里为这两个数学字体族补上可缩放（s*）的尺寸声明，使其按实际字号缩放，
% 既消除警告，也保证花体与向量箭头的字重与正文一致。
\DeclareFontFamily{U}{rsfs}{\skewchar\font127 }
\DeclareFontShape{U}{rsfs}{m}{n}{<->s*[0.96]rsfs10}{}
\DeclareFontFamily{U}{esvect}{}
\DeclareFontShape{U}{esvect}{m}{n}{<->s*[0.96]vect10}{}


% 显示带圈数字符号
\xeCJKDeclareCharClass{CJK}{"2460 -> "2469}


\newif\ifanswer %答案显示


\usepackage{ascolorbox}%答案框

%罗马数字大小写
\newcommand{\rmnum}[1]{\romannumeral #1}
\newcommand{\Rmnum}[1]{\expandafter\@slowromancap\romannumeral #1@}


\renewcommand{\ge}{\geqslant }%两种不同的大于等于符号
\renewcommand{\le}{\leqslant }%\geqslant需要\usepackage{ amssymb }宏包

 
\renewcommand{\labelenumi}{\chinese{enumi}、}
\renewcommand{\labelenumii}{(\arabic{enumii})}

\usepackage{braket} %量子算符宏包 


\usepackage{physicx}%排版矩阵 \commamatrix[b]{1; 0}

\usepackage{tabularray}%新型表格宏包，排版矩阵表格利器 %基本环境 tblr
\usepackage[upright=true]{derivative}%分数导数微分偏微分增量改变量等 

\usepackage{pifont}

\usepackage[normalem]{ulem}%下划线\uline{XXX}



%颜色的定义
\definecolor{mynote}{RGB}{255,134,24}%
\usepackage{manfnt}%其中的manfnt提供\textdbend的一个图形命令。包中还有很多图形命令
\newenvironment{note}{
  \par\noindent\makebox[-3pt][r]{
    \scriptsize\color{red!90}\textdbend~}
    \textbf{\color{mynote}笔记}~\kaishu}{\par}

    
    
    

%页脚
\usepackage{fancyhdr}

% 各年份试卷会在 \bta 中重新从第 1 页计数，因此不能使用全书的 LastPage
% 作为单卷总页数。这里在每个页面 shipout 时记录「当前卷的最大卷内页码」，
% 每卷结束时写入 .aux，页脚据此显示「第 N 页 / 共 M 页」。
% 首遍编译时页数未知，显示为 "?"，第二遍起即正确。
\makeatletter
% 每卷总页数，形如 \volend{2026}{9}
\newcommand{\volend}[2]{\expandafter\gdef\csname volend@#1\endcsname{#2}}
\newcommand{\volpages}[1]{%
    \ifcsname volend@#1\endcsname
        \csname volend@#1\endcsname
    \else ?\fi
}
% 当前卷内已排到的最大页码；每次 shipout 时更新
\newcounter{volmaxpage}
\newcommand{\volcurpage}{\the\value{volmaxpage}}
\AddToHook{shipout/before}{%
    \ifnum\value{page}>\value{volmaxpage}%
        \setcounter{volmaxpage}{\value{page}}%
    \fi
}
\makeatother

\fancypagestyle{mypagestyle}{%
	\fancyhf{}% Clear header/footer
		% 页码：单卷内从 1 计数，并给出该卷总页数
		\fancyfoot[OR]{第~\thepage~页 / 共~\volpages{\currentvol}~页}%
		\fancyfoot[EL]{第~\thepage~页 / 共~\volpages{\currentvol}~页}%
		% 左侧页脚标注科目，避免每页重复同一句话的冗余感改为卷名
		\fancyfoot[OL]{\currentvol~量子力学}%
		\fancyfoot[ER]{\currentvol~量子力学}%
	\renewcommand{\footrulewidth}{0.5pt}%
}



% 目录页码处理
% 各年份试卷会在 \bta 中把 page 计数器重置为 1。若直接使用 \addcontentsline
% 写目录，条目里的页码取自排版目录时的 \thepage，于是每一年在目录中都显示 1。
% 这里改为自行维护一个只在 shipout 时自增的绝对页码计数器，并把绝对页码作为
% 字面文本直接写入 .toc，从而得到该卷首页在整本 PDF 中的真实页码。
\makeatletter
\newcounter{absvolpage}
\AddToHook{shipout/before}{\stepcounter{absvolpage}}
% 当前正在排版的这一页的绝对页码（此时尚未 shipout，故需 +1）
% 注意：\newcounter 已自动定义 \theabsvolpage，故此处用 \renewcommand
\renewcommand{\theabsvolpage}{\the\numexpr\value{absvolpage}+1\relax}
% 卷序号：只按「第几卷」自增，与页码无关——这是书签锚点名必须稳定的原因，
% 详见 \absvolcontentsline 的说明 3)。
\newcounter{volseq}
% 将某卷的目录条目写入 .toc
% 四个要点：
%   1) 页码：不能依赖 \thepage（排版目录时才解析，且各卷页码被重置为 1），
%      故用 \addtocontents 把绝对页码作为字面文本直接写进 .toc。
%   2) 跳转：第 4 个参数必须是 hyperref 的有效锚点名，条目才可点击。
%      该锚点名取自 \phantomsection 之后的 \@currentHref，须立即展开保存。
%   3) 书签：\addtocontents 是裸写入，绕过了 hyperref 的 \addcontentsline，
%      因此不会生成 PDF 书签，阅读器侧边栏目录会是空的；需另用 \pdfbookmark 补上。
%   4) 书签的锚点名绝不能含页码（曾用 vol\theabsvolpage，已废弃）：
%      hyperref 把书签写进 .out，下一遍才读回来生成 PDF 侧边栏，而 \pdfbookmark
%      在当遍创建同名的目标点。若名字由页码决定，一旦分页在两遍之间变化
%      （例如目录从 1 页涨到 2 页），.out 里的名字就与当遍创建的目标点错开，
%      29 个条目会全部指向不存在的位置——侧边栏看着有条目，点了却毫无反应，
%      等同于「侧边栏内容消失」。用与页码无关的 volseq 才稳定。
\newcommand{\absvolcontentsline}[1]{%
    \phantomsection
    \xdef\absvolanchor{\@currentHref}%
    \pdfbookmark[0]{#1 量子力学}{vol\thevolseq}%
    \addtocontents{toc}{%
        \protect\contentsline{chapter}{#1 量子力学}{\theabsvolpage}{\absvolanchor}%
    }%
}
% 每卷的末页页码（卷内相对页码）
% \bta 会在每卷开头把 page 计数器重置为 1，故卷内最大页码即该卷总页数。
\newcommand{\volendmark}[1]{%
    \immediate\write\@mainaux{\string\volend{#1}{\volcurpage}}%
}
% 结算上一卷：在 \bta 开头调用，把上一卷的总页数写入 .aux
\newcommand{\closeprevvol}{%
    \ifx\currentvol\@empty\else
        \volendmark{\currentvol}%
    \fi
}
\AtEndDocument{\closeprevvol}
\makeatother
% \currentvol 初值为空，表示尚未开始任何一卷
\def\currentvol{}

\newcommand{\bta}[1]{%
    % 开始新卷前，先结算上一卷的末页绝对页码
    \closeprevvol
    \stepcounter{volseq}%为书签提供与页码无关的稳定锚点名
    \setcounter{page}{1}%设置页面计数器
    % 记录当前卷名，供页脚显示
    \gdef\currentvol{#1}%
    % 重置卷内最大页码
    \setcounter{volmaxpage}{0}%
    % 写入目录条目（使用绝对页码，避免每年重置页码后目录全为 1）
    \absvolcontentsline{#1}%
    \chaptermark{#1 量子力学}%
    %\renewcommand{\mypagenote}{#1}
	%\songti
	%\zihao{5}
%量子力学标题
\begin{center}
	\zihao{4}\heiti
	中国科学院大学\\
	#1 年招收攻读硕士学位研究生入学统一考试试题\\
	科目名称:量子力学

\end{center}
\noindent
考生须知：\\
1.本试卷满分为150分,全部考试时间总计180分钟。\\
2.所有答案必须写在答题纸上,写在试题纸上或草稿纸上一律无效。

\vspace*{2ex}
\hrule
\vspace*{4ex}


}


\newcommand{\xzanswer}[1]{%
\ifanswer
	  $ (~\textcolor{red!60!black}{#1}~) $
\else
      $ ( \quad ) $
\fi}



\newcommand{\banswer}[1]{%
\ifanswer
\begin{ascolorbox2}{}[colframe=gray!50!white, coltext=red!60!black,colback=gray!5!white,]
%\ascboxA{解}
\textcolor{red!80}{解：}
#1
\end{ascolorbox2}
    \vfill %垂直分列，自动划分大题的空白
\else
    \vfill %垂直分列，自动划分大题的空白
\fi}



%四个选项的处理
\usepackage{xstring,xifthen}
\newlength{\choicelengtha}
\newlength{\choicelengthb}
\newlength{\choicelengthc}
\newlength{\choicelengthd}
\newlength{\choicelengthe}
\newlength{\maxlength}
\newcommand{\fourchoices}[4]
{
	\settowidth{\choicelengtha}{A.~#1~}
	\settowidth{\choicelengthb}{B.~#2~}
	\settowidth{\choicelengthc}{C.~#3~}
	\settowidth{\choicelengthd}{D.~#4~}
	\ifthenelse{\lengthtest{\choicelengtha>\choicelengthb}}{\setlength{\maxlength}{\choicelengtha}}{\setlength{\maxlength}{\choicelengthb}}
	\ifthenelse{\lengthtest{\choicelengthc>\maxlength}}{\setlength{\maxlength}{\choicelengthc}}{}
	\ifthenelse{\lengthtest{\choicelengthd>\maxlength}}{\setlength{\maxlength}{\choicelengthd}}{}
	\ifthenelse{\lengthtest{\maxlength>0.49\linewidth}}%万事留一线(防止意外)
	{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut%\raggedright%使用\raggedright会导致超长公式不能自动换行
	#1\strut}%
\\
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut%\raggedright%使用\raggedright会导致超长公式不能自动换行
	#2\strut}%
\\
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut%\raggedright%使用\raggedright会导致超长公式不能自动换行
	#3\strut}%
\\
\parbox[t]%
{1.5em}{\hfill D.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut%\raggedright%使用\raggedright会导致超长公式不能自动换行
	#4\strut}%
%\vspace{\parskip}
\par
	}
	{
		\ifthenelse{\lengthtest{\maxlength>0.24\linewidth}}%万事留一线(防止意外)
		{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\raggedright%
	#1}\hfill%
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\raggedright%
	#2}
\\
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\raggedright%
	#3}\hfill%
\parbox[t]%
{1.5em}{\hfill D.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\strut\raggedright%
	#4\strut}
%\vspace{\parskip} %这里，当有四个的时候自动会有parskip空行，原因未知
\par
		}
		{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\raggedright%
	#1}\hfill%
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\raggedright%
	#2}\hfill%
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\raggedright%
	#3}\hfill%
\parbox[t]%
{1.5em}{\hfill D.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\strut\raggedright%
	#4\strut}
%\vspace{\parskip} %这里，当有四个的时候自动会有parskip空行，原因未知
\par
		}
	}
}



%对与四个选项为图像时进行特殊处理

\newcommand{\pfourchoices}[4]
{
	\settowidth{\choicelengtha}{A.~#1~}
	\settowidth{\choicelengthb}{B.~#2~}
	\settowidth{\choicelengthc}{C.~#3~}
	\settowidth{\choicelengthd}{D.~#4~}
	\ifthenelse{\lengthtest{\choicelengtha>\choicelengthb}}{\setlength{\maxlength}{\choicelengtha}}{\setlength{\maxlength}{\choicelengthb}}
	\ifthenelse{\lengthtest{\choicelengthc>\maxlength}}{\setlength{\maxlength}{\choicelengthc}}{}
	\ifthenelse{\lengthtest{\choicelengthd>\maxlength}}{\setlength{\maxlength}{\choicelengthd}}{}
	\ifthenelse{\lengthtest{\maxlength>0.49\linewidth}}%万事留一线(防止意外)
	{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#1\strut}%
\\
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#2\strut}%
\\
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#3\strut}%
\\
\parbox[t]%
{1.5em}{\hfill D.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#4\strut}%
%\vspace{\parskip}
\par
	}
	{
		\ifthenelse{\lengthtest{\maxlength>0.24\linewidth}}%万事留一线(防止意外)
		{
\par
\noindent
\begin{minipage}[h!]{0.49\linewidth}
 	\centering
 	#1\par
 	A.\vspace{1.5em}
\end{minipage}
 \hfill
\begin{minipage}[h!]{0.49\linewidth}
 	\centering
 	#2\par
 	B.\vspace{1.5em}
 \end{minipage}
\\
\begin{minipage}[h!]{0.49\linewidth}
 	\centering
 	#3\par
 	C.\vspace{0.9em}
\end{minipage}
 \hfil
\begin{minipage}[h!]{0.49\linewidth}
 	\centering
 	#4\par
 	D.\vspace{0.9em}
 \end{minipage}
%\vspace{\parskip} %这里，当有四个的时候自动会有parskip空行，原因未知
\par
		}
		{
\par
\noindent
\begin{minipage}[t]{0.245\linewidth}
 	\centering
 	#1\par
 	A.\vspace{0.9em}
 \end{minipage}
\begin{minipage}[t]{0.245\linewidth}
 	\centering
 	#2\par
 	B.\vspace{0.9em}
 \end{minipage}
\begin{minipage}[t]{0.245\linewidth}
 	\centering
 	#3\par
 	C.\vspace{0.9em}
 \end{minipage}
\begin{minipage}[t]{0.245\linewidth}
 	\centering
 	#4\par
 	D.\vspace{0.9em}
 \end{minipage}
%\vspace{\parskip} %这里，当有四个的时候自动会有parskip空行，原因未知
\par
		}
	}
}


%对选择题的三个选项处理
\newlength{\threechoicelengtha}
\newlength{\threechoicelengthb}
\newlength{\threechoicelengthc}
\newlength{\threemaxlength}
\newcommand{\threechoices}[3]
{
	\settowidth{\threechoicelengtha}{A.~#1~}
	\settowidth{\threechoicelengthb}{B.~#2~}
	\settowidth{\threechoicelengthc}{C.~#3~}
	\ifthenelse{\lengthtest{\threechoicelengtha>\threechoicelengthb}}{\setlength{\threemaxlength}{\threechoicelengtha}}{\setlength{\threemaxlength}{\threechoicelengthb}}
	\ifthenelse{\lengthtest{\threechoicelengthc>\threemaxlength}}{\setlength{\threemaxlength}{\threechoicelengthc}}{}
	\ifthenelse{\lengthtest{\threemaxlength>0.49\linewidth}}
	{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#1\strut}%
\\
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#2\strut}%
\\
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{\linewidth-1.7em}{\strut\raggedright%
	#3\strut}%
%\vspace{\parskip}
\par
	}
	{
		\ifthenelse{\lengthtest{\threemaxlength>0.24\linewidth}}
		{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\raggedright%
	#1}\hfill%
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\raggedright%
	#2}
\\
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{0.5\linewidth-1.7em}{\strut\raggedright%
	#3\strut}\hfill%
%\vspace{\parskip}
\par
		}
		{
\par
\noindent
\parbox[t]%
{1.5em}{\hfill A.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\raggedright%
	#1}%
\parbox[t]%
{1.5em}{\hfill B.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\raggedright%
	#2}%
\parbox[t]%
{1.5em}{\hfill C.}\hskip0.2em%
\parbox[t]{0.25\linewidth-1.7em}{\strut\raggedright%
	#3\strut}\hfill%
%\vspace{\parskip}
\par
		}
	}
}
