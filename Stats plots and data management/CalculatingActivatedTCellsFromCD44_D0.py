#!/usr/bin/env python
# coding: utf-8

# In[23]:


import pandas as pd
import numpy as np
from collections import Counter

####################
#Preparing My Data #
####################
pop = pd.read_csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/NaiveTregDifferentiation.csv")
# Choosing spleen only data

Splnpop = pop.loc[pop['Organ'] == 'Spleen']

# Removing Ages that we do not have information on in the pop file
CD69Ages = [0, 4, 7, 9, 12, 14, 18]
ActivatedCD4pop = Splnpop[Splnpop.Age.isin(CD69Ages)].copy()

########################################
# Preparing Genevieves Activation Data #
########################################

CD44df = pd.read_csv('~/my.work/PhD/HomestaticExpansionProject/ModelData/TCellActivationSummary_EdittedinR.csv')

#Selecting only the columns that we want
CD44df = CD44df[[ 'Age', 'Genotype', 'AcivatedCells_pct']]
#Grouping and finding the mean
GmCD44 = CD44df.groupby( [ "Age", "Genotype"] ).mean().reset_index()

#########################################
# Calculating all activated CD4 T cells #
#########################################

def NumOfActivatedCD4(grp):
    '''
    This will take one pop group and finds the equivalent group from the GmCD44 group, 
    then takes the percentage from the appropriate GmCD44 percentage and multiplies it to the pop CD4CT group.
    Requirement:
         age = grp.name[0]
         Genotype = str(grp.name[1])
    '''

#The CD4Tcell groups equivalent to the CD69 data groups. This 
    pct = GmCD44.loc[(GmCD44['Age'] == grp.name[0]) & (GmCD44['Genotype']==str(grp.name[1]))]['AcivatedCells_pct'].iloc[0]
    pct = pct / 100
    return grp * pct
    
# Translation of the groupby: make groups out of age and Genotype, 
#then take the CD4CT value run it through the function
ActivatedCD4pop['ActivatedCD4CT'] = ActivatedCD4pop.groupby( [ "Age", "Genotype"] )['NoTregCD4CT'].apply(NumOfActivatedCD4)

ActivatedCD4pop.to_csv('/home/jon/my.work/PhD/HomestaticExpansionProject/ModelData/ActivatedCD4pop2_D0.csv')

