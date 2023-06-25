#!/usr/bin/env python
# coding: utf-8

# In[1]:


from sympy import var
from sympy import solve


# In[2]:


#function that returns dy/dt
N, T, I, R = var('N T I R')
alpha, epsilon, a, c, b_R = var('alpha epsilon a c b_R')
mu, beta, kA, n, g = var('mu beta kA n g')
b_T = var('b_R')
d, e_T, e_R, f = var('d e_T e_R f')


# In[5]:


############
#  Thymus  #
############
alpha = 0.006 #------------ T Regulatory Cells
mu = 60   #---------- Naive T cells
Thy = 1 #------------ Size of the thymus
Thy_max = 1 #------- Max size of the thymus

#########################################
#  Naive T cell Differentiation Rates   #
#########################################
c = 0.01 #--------To T regulatory Cells
beta = 10 #------ To activated T cells

###########
#  Tregs  #
###########
epsilon = 1 #------------T regulatory cell Self replication
z       = 1 #------- Strength of suppression on Naive T cell differention to activation
n       = 1 #hill coefficient
kA      = 10 #halfSaturationRate 

##############################################
#  IL-2 Cytokine Expression and Consumption  #
##############################################
# d = 0.01 #------- T Cell Expression
a = 0.1   #------------Activated T cells
e_T = 0.01 #------ T Cell Consumption Rate
e_R = 0.01 #------ T Reg Consumption Rate

##################
#  Death Rates   #
##################
g = 0.01 #-----------Naive T cells
b_T = 0.1 #-----------Activated T cells
b_R = 0.1 #----------Regulatory T Cells
f = 1 #-------------IL-2 Cytokine

N = 50
T = 30
I = 0.5
R = 20


# In[6]:


dRdt = alpha + (epsilon * a * I * R) + (c * N) - (b_R * R)
dNdt = mu - beta*N*(1/(1+(R/kA)**n)) - c*N - g*N 
dTdt = beta*N*(1/(1+(R/kA)**n)) + a*I*T - b_T*T
dIdt = d*T - e_T*I*T - e_R*I*R - f*I

sols = solve([dRdt, dNdt, dTdt, dIdt], [R, N, T, I])


# In[7]:


sols

