---
## Front matter
title: "Отчёт по лабораторной работе №6"
subtitle: "Задача об эпидемии"
author: "Желдакова Виктория Алексеевна"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: PT Serif
romanfont: PT Serif
sansfont: PT Sans
monofont: PT Mono
mainfontoptions: Ligatures=TeX
romanfontoptions: Ligatures=TeX
sansfontoptions: Ligatures=TeX,Scale=MatchLowercase
monofontoptions: Scale=MatchLowercase,Scale=0.9
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Изучить и построить модель эпидемии с помощью языков OpenModelica и Julia.

# Задание

## Вариант 16

На одном острове вспыхнула эпидемия. Известно, что из всех проживающих на острове $(N=10 100)$ в момент начала эпидемии $(t=0)$ число заболевших людей (являющихся распространителями инфекции) $I(0)=66$, А число здоровых людей с иммунитетом к болезни $R(0)=26$. Таким образом, число людей восприимчивых к болезни, но пока здоровых, в начальный момент времени $S(0)=N-I(0)- R(0)$.

Постройте графики изменения числа особей в каждой из трех групп. Рассмотрите, как будет протекать эпидемия в случае: 

1.	$I(0)\leq I^*$
2.	$I(0)>I^*$

# Теоретическое введение

Рассмотрим простейшую модель эпидемии. Предположим, что некая популяция, состоящая из $N$ особей, (считаем, что популяция изолирована) подразделяется на три группы. Первая группа - это восприимчивые к болезни, но пока здоровые особи, обозначим их через $S(t)$. Вторая группа – это число инфицированных особей, которые также при этом являются распространителями инфекции, обозначим их $I(t)$. А третья группа, обозначающаяся через $R(t)$ – это здоровые особи с иммунитетом к болезни.

До того, как число заболевших не превышает критического значения $I^*$, считаем, что все больные изолированы и не заражают здоровых. Когда $I(0)>I^*$, тогда инфицирование способны заражать восприимчивых к болезни особей. Таким образом, скорость изменения числа $S(t)$ меняется по следующему закону:

$$
\frac{dS}{dt}=
 \begin{cases}
	-\alpha S &\text{,если $I(t) > I^*$}
	\\   
	0 &\text{,если $I(t) \leq I^*$}
 \end{cases}
$$

Поскольку каждая восприимчивая к болезни особь, которая, в конце концов, заболевает, сама становится инфекционной, то скорость изменения числа инфекционных особей представляет разность за единицу времени между заразившимися и теми, кто уже болеет и лечится, т.е.:

$$
\frac{dI}{dt}=
 \begin{cases}
	\alpha S -\beta I &\text{, если $I(t) > I^*$}
	\\   
	-\beta I &\text{, если $I(t) \leq I^*$}
 \end{cases}
$$

А скорость изменения выздоравливающих особей (при этом приобретающие иммунитет к болезни)

$$\frac{dR}{dt} = \beta I$$

Для того, чтобы решения соответствующих уравнений определялось однозначно, необходимо задать начальные условия. Считаем, что на начало эпидемии в момент времени $t=0$ нет особей с иммунитетом к болезни $R(0)=0$, а число инфицированных и восприимчивых к болезни особей $I(0)$ и $S(0)$ соответственно. Для анализа картины протекания эпидемии необходимо
рассмотреть два случая: $I(0)\leq I^*$ и $I(0)>I^*$

# Выполнение лабораторной работы

## Решение с помощью языков программирования

### OpenModelica

Код программы для случая с изолированными больными [1]:
```
model lab06_1
Real N = 10100;
Real I;
Real R;
Real S;
Real alpha = 0.2;
Real beta = 0.6; 
initial equation
I = 66;
R = 26;
S = N - I - R;
equation
der(S) = 0;
der(I) = -beta*I;
der(R) = beta*I;
end lab06_1;
```

В результате работы программы получаем следующий график: (рис. [-@fig:001]).

![График протекания эпидемии в условиях изоляции зараженных](image/1.png){#fig:001 width=70%}

Код программы для случая, когда инфицированные способны заражать восприимчивых к болезни особей:
```
model lab06_2
Real N = 10100;
Real I;
Real R;
Real S;
Real alpha = 0.4;
Real beta = 0.2; 
initial equation
I = 66;
R = 26;
S = N - I - R;
equation
der(S) = -alpha*S;
der(I) = alpha*S - beta*I;
der(R) = beta*I;
end lab06_2;
```
В результате работы программы получаем следующий график: (рис. [-@fig:002]).

![График протекания эпидемии в условиях, инфицированные способны заражать восприимчивых к болезни особей](image/2.png){#fig:002 width=70%}

### Julia

Код программы для случая с изолированными больными [2]:
```
using Plots
using DifferentialEquations

N = 10100
I0 = 66
R0 = 26
S0 = N - I0 - R0

alpha = 0.2
beta = 0.6

function ode_fn(du, u, p,t)
	S, I, R = u
	du[1] = 0
	du[2] = -beta*u[2]
	du[3] = beta*I
end

v0 = [S0, I0, R0]
tspan = (0.0, 60.0)
prob = ODEProblem(ode_fn, v0, tspan)
sol = solve(prob, dtmax = 0.05)
S = [u[1] for u in sol.u]
I = [u[2] for u in sol.u]
R = [u[3] for u in sol.u]
T = [t for t in sol.t]

plt = plot(dpi=600, legend=:topright)
plot!(plt, T, S, label = "Восприимчивые особи", color=:blue)
plot!(plt, T, I, label = "Инфицированные особи", color=:green)
plot!(plt, T, R, label = "Особи с иммунитетом", color=:red)

savefig(plt, "lab06_1.png")
```

В результате работы программы получаем следующий график: (рис. [-@fig:003]).

![График протекания эпидемии в условиях изоляции зараженных](image/3.png){#fig:003 width=70%}

Код программы для случая, когда инфицированные способны заражать восприимчивых к болезни особей:
```
using Plots
using DifferentialEquations

N = 10100
I0 = 66
R0 = 26
S0 = N - I0 - R0

alpha = 0.4
beta = 0.2

function ode_fn(du, u, p,t)
	S, I, R = u
	du[1] = -alpha*u[1]
	du[2] = alpha*u[1] - beta*u[2]
	du[3] = beta*I
end

v0 = [S0, I0, R0]
tspan = (0.0, 80.0)
prob = ODEProblem(ode_fn, v0, tspan)
sol = solve(prob, dtmax = 0.05)
S = [u[1] for u in sol.u]
I = [u[2] for u in sol.u]
R = [u[3] for u in sol.u]
T = [t for t in sol.t]

plt = plot(dpi=600, legend=:right)
plot!(plt, T, S, label = "Восприимчивые особи", color=:blue)
plot!(plt, T, I, label = "Инфицированные особи", color=:green)
plot!(plt, T, R, label = "Особи с иммунитетом", color=:red)

savefig(plt, "lab06_2.png")
```
В результате работы программы получаем следующий график: (рис. [-@fig:004]).

![График протекания эпидемии в условиях, инфицированные способны заражать восприимчивых к болезни особей](image/4.png){#fig:004 width=70%}

## Анализ

Графики в OpenModelica получились идентичными с графиками, полученными с помощью Julia. 

# Выводы

Изучили и построили модель эпидемии с помощью языков OpenModelica и Julia.

# Список литературы{.unnumbered}

[1] Документация по OpenModelica: https://openmodelica.org/

[2] Документация по Julia: https://docs.julialang.org/en/v1/
