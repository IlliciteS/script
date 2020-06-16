#!/bin/bash


######## NOMBRE DE MATCH A EFFECTUER ###################
Nombre_Match_Total=1

########## JOUEUR 1 ######################################################
######Profil

name1="Joueur 1"
desc1="(Esquive)"
FOR1=10
END1=10
ATT1=10
INI1=12
HAB1=10
NA1_Initial=1 #Ne bougeront jamais
NA1=1 # Diminueront au fur et à mesure du combat
PV1_Initial=60 #Ne bougeront jamais
PV1=60 #Diminueront au fur et à mesure du combat
ARM1=5


###Arme: épée courte
DGT1=12
AVE_DGT1=4


###### JOUEUR 2 ##########################################################
##Profil
name2="Joueur 2"
desc2="(Parade)"
FOR2=10
END2=10
ATT2=10
INI2=11
PAR2=10
NA2_Initial=2 #Ne bougeront jamais
NA2=2
PV2_Initial=60 #Ne bougeront jamais
PV2=60 #Diminueront au fur et à mesure du combat
ARM2=5

## SPECIFICITES PARADE ##
Bouclier2="Non"
Competence_Parade2="Non"

####Arme : épée courte
DGT2=12
AVE_DGT2=4
BLK2=9

############## AUTRES #####################################################
Deja_Defendu2="Non"
Deja_Defendu1="Non"
Nombre_Round=1
Nombre_Touch_Reussie1=0
Nombre_Touch_Failed1=0
Nombre_Touch_Reussie2=0
Nombre_Touch_Failed2=0
Nombre_Degat_Potentiel1=0
Nombre_Degat_Potentiel1=0
Nombre_Degat_Reel1=0
Nombre_Degat_Reel2=0
Nombre_Esq_Failed1=0
Nombre_Esq_Tente1=0
Nombre_Esq_Reussie1=0
Nombre_Par_Failed2=0
Nombre_Par_Tente2=0
Nombre_Par_Reussie2=0
Nombre_Degat_Dodge1=0
Nombre_Degat_Reel_Pare2=0
PV_Restant_Total1=0
PV_Restant_Total2=0
Victoire1=0
Victoire2=0
Nombre_Match=$Nombre_Match_Total

#############
# Fonctions #
#############

#Qui commence le fight, comparatif d'INI entre les deux joueurs
Who_start_fight()
{
	if [[ "$INI1" -gt "$INI2" ]];
	then
		Touch1
	else
		Touch2
	fi
}

#Check si les deux joueurs ont 0 NA => New round. 
Check_All_NA()
{
	if [ "$NA1" -eq 0 ];
	then
		if [ "$NA2" -eq 0 ];
		then
			echo " Les deux joueurs n'ont plus de NA"
			echo "Nouveau Round"
			Reinitialisation_Carac_New_Round
			Nombre_Round=$((Nombre_Round +1))
			Display_Round
			Who_start_fight
		fi
	fi
}

Check_NA()
{
	if [[ "$Attaquant" == "J2" ]];
	then
		if [[ "$NA1" -gt 0 ]];
		then
			Touch1
		elif [[ "$NA2" -gt 0 ]];
		then
			Touch2
		else
			echo " Les deux joueurs n'ont plus de NA"
			echo "Nouveau Round"
			Reinitialisation_Carac_New_Round
			Nombre_Round=$((Nombre_Round +1))
			Display_Round
			Who_start_fight
		fi
	else
		if [[ "$NA2" -gt 0 ]];
		then
			Touch2
		elif [[ "$NA1" -gt 0 ]];
		then
			Touch1
		else
			echo " Les deux joueurs n'ont plus de NA"
			echo "Nouveau Round"
			Reinitialisation_Carac_New_Round
			Nombre_Round=$((Nombre_Round +1))
			Display_Round
			Who_start_fight
		fi
	fi
}


#Check si J1 a plus de NA => Passe son tour.
Check_NA1()
{
	if [[ "$NA1" -eq 0 ]];
	then
		echo "Joueur 1 $desc1 n'a plus de NA et passe son tour"
		Touch2
	fi
	Touch1
}

#Check si J2 a plus de NA => Passe son tour.
Check_NA2()
{
	if [[ "$NA2" -eq 0 ]];
	then
		echo "Joueur 2 $desc1 n'a plus de NA et passe son tour"
		Touch1
	fi
	Touch2
}

Touch1()
{
	Attaquant="J1"
	echo " "
	echo "Joueur 1 $desc1 dispose de $NA1 NA et attaque"
	Jet_Touch1=$((1 + RANDOM % 20))
	if [[ "$Jet_Touch1" -gt "$ATT1" ]];
	then
		echo "L'attaque de ${name1} $desc1 a échoué ( $Jet_Touch1 > $ATT1 )"
		Nombre_Touch_Failed1=$((Nombre_Touch_Failed1 +1))
		NA1=$((NA1 - 1))
		Check_NA
	else
		echo "L'attaque de ${name1} $desc1 a réussi ( $Jet_Touch1 < $ATT1 )"
		NA1=$((NA1 - 1))
		Nombre_Touch_Reussie1=$((Nombre_Touch_Reussie1 +1))
		Nombre_Degat_Potentiel1=$((Nombre_Degat_Potentiel1 + FOR1 *2 + DGT1 + AVE_DGT1))
		Test_Parade2
	fi
}

Touch2()
{
	Attaquant="J2"
	echo " "
	echo "Joueur 2 $desc2 dispose de $NA2 NA et attaque"
	Jet_Touch2=$((1 + RANDOM % 20))
	if [[ "$Jet_Touch2" -gt "$ATT2" ]];
	then
		echo "L'attaque de ${name2} $desc2 a échoué ( $Jet_Touch2 > $ATT2 )"
		Nombre_Touch_Failed2=$((Nombre_Touch_Failed2 +1))
		NA2=$((NA2 - 1))
		Check_NA
	else
		echo "L'attaque de ${name2} $desc2 a réussi ( $Jet_Touch2 < $ATT2 )"
		NA2=$((NA2 - 1))
		Nombre_Touch_Reussie2=$((Nombre_Touch_Reussie2 +1))
		Nombre_Degat_Potentiel2=$((Nombre_Degat_Potentiel2 + FOR2 *2 + DGT2 + AVE_DGT2))
		Test_Esquive1
	fi
}

Test_Parade2()
{
	Check_Deja_Denfendu2
	Jet_Par2=$((1 + RANDOM % 20))
	Deja_Defendu2="Oui"
	if [[ "$Jet_Par2" -gt "$PAR2" ]];
	then
		echo "La parade de ${name2} $desc2 a échoué ( $Jet_Par2 > $PAR2 )"
		if [[ "$Bouclier2" == "Oui" ]];
		then
			echo "Le joueur 2 possède un bouclier et peut donc relancer sa parade"
			Jet_Par2=$((1 + RANDOM % 20))
			if [[ "$Jet_Par2" -gt "$PAR2" ]];
			then
				echo "La relance parade de ${name2} $desc2 a échoué ( $Jet_Par2 > $PAR2 )"
				Nombre_Par_Failed2=$((Nombre_Par_Failed2 +1))
				Degat_Flat1
			else
				echo "La relance parade de ${name2} $desc2 a réussi ( $Jet_Par2 < $PAR2 )" 
				Nombre_Par_Reussie2=$((Nombre_Par_Reussie2 +1 ))
				Degat_Parade1
			fi
		fi
		Nombre_Par_Failed2=$((Nombre_Par_Failed2 +1))
		Degat_Flat1
	else
		echo "La parade de ${name2} $desc2 a réussi ( $Jet_Par2 < $PAR2 )"
		Nombre_Par_Reussie2=$((Nombre_Par_Reussie2 +1 ))
		Degat_Parade1
	fi
}

Test_Esquive1()
{
	Check_Deja_Denfendu1
	echo "Joueur 1 $desc1 tente d'esquiver"
	Deja_Defendu1="Oui"
	Jet_Esq1=$((1 + RANDOM % 20))
	if [[ "$Jet_Esq1" -gt "$HAB1" ]];
	then
		echo "Esquive Joueur 1 $desc1 échouée ( $Jet_Esq1 > $HAB1 )"
		Degat_Flat2
	else
		echo "Jet d'esquive réussi ( $Jet_Esq1 < $HAB1 )"
		Nombre_Esq_Tente1=$((Nombre_Esq_Tente1 +1))
		echo "Comparatif de degrés de réussite"
		Degre_Att2=$(( ATT2 - Jet_Touch2 ))
		echo "Degrés d'attaque du J2 $desc2 : $Degre_Att2 "
		Degre_Esq1=$((HAB1 - Jet_Esq1 ))
		echo "Degrés d'esquive du J1 $desc1 : $Degre_Esq1 "
		if [[ "$Degre_Att2" -gt "$Degre_Esq1" ]];
		then
			echo "Esquive du joueur 1 $desc1 échouée ; il se prend tous les dégâts de l'attaque"
			Nombre_Esq_Failed1=$((Nombre_Esq_Failed1 +1))
			Degat_Flat2
		else
			echo "Esquive du joueur 1 $desc1 réussie"
			Dodge_Damage1=$((FOR2 * 2 + DGT2 + AVE_DGT2 - END1 - ARM1))
			echo "Dégâts évités : ($FOR2 * 2 + $DGT2 + $AVE_DGT2 - $END1 - $ARM1) = $Dodge_Damage1 "
			echo "Dégâts reçus : 0"
			Nombre_Degat_Dodge1=$((Nombre_Degat_Dodge1 + Dodge_Damage1))
			echo "Accumulation réduction : $Nombre_Degat_Dodge1"
			echo "Pv joueur 1 $desc1 : $PV1 "
			Nombre_Esq_Reussie1=$((Nombre_Esq_Reussie1 +1))
			Check_NA
		fi
	fi
}


#Dégât sans par/esquive provoqué par le joueur 1 au J2
Degat_Flat1()
{
	Degat_Flat_By_J1=$((FOR1 * 2 + DGT1 + AVE_DGT1 - END2 - ARM2 ))
	echo "Dégâts infligés : $FOR1 * 2 + $DGT1 + $AVE_DGT1 - $END2 - $ARM2 = $Degat_Flat_By_J1"
	Nombre_Degat_Reel1=$((Nombre_Degat_Reel1 + Degat_Flat_By_J1))
	PV_Restant2
}

#Dégât sans par/esquive provoqué par le joueur 2 au J1
Degat_Flat2()
{
	Degat_Flat_By_J2=$((FOR2 * 2 + DGT2 + AVE_DGT2 - END1 - ARM1 ))
	echo "Dégâts infligés : $FOR2 * 2 + $DGT2 + $AVE_DGT2 - $END1 - $ARM1 = $Degat_Flat_By_J2"
	Nombre_Degat_Reel2=$((Nombre_Degat_Reel2 + Degat_Flat_By_J2))
	PV_Restant1
}

#Dégât avec parade provoqué par le joueur 1 au J2
Degat_Parade1()
{
	if [[ "$Competence_Parade2" == "Oui" ]];
	then
		echo "Le joueur 2 a la compétence parade et sa valeur de parade d'arme ou bouclier est doublée"
		Reduc_Degat2=$((END2 + ARM2 + BLK2 * 2))
		Degat_Parade_By_J1=$((FOR1 * 2 + DGT1 + AVE_DGT1 - Reduc_Degat2))
		if [[ "$Degat_Parade_By_J1" -lt 0 ]];
		then
			Degat_Parade_By_J1=0
		fi
		echo "Dégâts réduits : $END2 + $ARM2 + $BLK2 * 2 = $Reduc_Degat2"
		echo "Dégâts infligés : $FOR1 * 2 + $DGT1 + $AVE_DGT1 - $END2 - $ARM2 - $BLK2 *2 = $Degat_Parade_By_J1 "
		Nombre_Degat_Reel_Pare2=$((Nombre_Degat_Reel_Pare2 + Reduc_Degat2))
		echo "Accumulation réduction : $Nombre_Degat_Reel_Pare2"
		Nombre_Degat_Reel1=$((Nombre_Degat_Reel1 + Degat_Parade_By_J1))
		PV_Par_Restant2
	else
		Degat_Parade_By_J1=$((FOR1 * 2 + DGT1 + AVE_DGT1 - END2 - ARM2 - BLK2))
		if [[ "$Degat_Parade_By_J1" -lt 0 ]];
		then
			Degat_Parade_By_J1=0
		fi
		Reduc_Degat2=$((END2 + ARM2 + BLK2))
		echo "Dégâts réduits : $END2 + $ARM2 + $BLK2 = $Reduc_Degat2"
		echo "Dégâts infligés : $FOR1 * 2 + $DGT1 + $AVE_DGT1 - $END2 - $ARM2 - $BLK2 = $Degat_Parade_By_J1 "
		Nombre_Degat_Reel_Pare2=$((Nombre_Degat_Reel_Pare2 + Reduc_Degat2))
		echo "Accumulation réduction : $Nombre_Degat_Reel_Pare2"
		Nombre_Degat_Reel1=$((Nombre_Degat_Reel1 + Degat_Parade_By_J1))
		PV_Par_Restant2
	fi
}


#PV restant pour le joueur 1 sans parade
PV_Restant1()
{
	echo "PV restants : $PV1 - $Degat_Flat_By_J2 "
	PV1=$((PV1 - Degat_Flat_By_J2))
	echo " Le joueur 1 $desc1 a $PV1 PV restants"
	echo " "
	Victory_Condition
	
}

#PV restant pour le joueur 2 après parade
PV_Par_Restant2()
{
	echo "PV restants : $PV2 - $Degat_Parade_By_J1"
	PV2=$((PV2 - Degat_Parade_By_J1))
	echo " Le joueur 2  $desc2 a $PV2 PV restants"
	echo " "
	Victory_Condition
}

#PV restant pour le joueur 2 sans parade
PV_Restant2()
{
	echo " PV restants : $PV2 - $Degat_Flat_By_J1 "
	PV2=$((PV2 - Degat_Flat_By_J1))
	echo " Le joueur 2 $desc2 a $PV2 PV restants "
	echo " "
	Victory_Condition
	
}



#Vérifier qui a zéro PV. Si aucun, on skip.
Victory_Condition()
{
	if [[ "$PV1" -le 0 ]];
	then
		echo " Le joueur 2 $desc2 a gagné ($PV2 contre $PV1)"
		PV_Restant_Total2=$((PV_Restant_Total2 + PV2))
		Victoire2=$((Victoire2 +1))
		Nombre_Match=$((Nombre_Match -1))
		return
	elif [[ "$PV2" -le 0 ]];
	then
		echo "Le joueur 1 $desc1 a gagné ($PV1 contre $PV2)"
		PV_Restant_Total1=$((PV_Restant_Total1 + PV1))
		Victoire1=$((Victoire1 +1))
		Nombre_Match=$((Nombre_Match -1))
		return
	else
		Check_NA
	fi
}

#Affichage pour segmenter le fight en rounds
Display_Round()
{
	echo " "
	echo "	[ROUND] -- $Nombre_Round "
	echo " "
}

#Réinitialisation des NA et de l'option défensive à chaque new round
Reinitialisation_Carac_New_Round()
{
	Deja_Defendu1="Non"
	Deja_Defendu2="Non"
	NA1=$NA1_Initial
	NA2=$NA2_Initial
	
}

Reinitialisation_Carac_New_Match()
{
	Nombre_Round=1
	Display_Round
	PV1=$PV1_Initial
	PV2=$PV2_Initial
	NA1=$NA1_Initial
	NA2=$NA2_Initial
	Deja_Defendu2="Non"
	Deja_Defendu1="Non"
	
}

#Check si J1 a déjà tenté d'esquiver.
Check_Deja_Denfendu1()
{
	if [[ "$Deja_Defendu1" != "Non" ]];
	then
		echo "Le joueur 1 a déjà tenté d'esquiver et ne peut plus se défendre"
		Degat_Flat2
	fi		
}

#Check si J2 a déjà tenté de parer.
Check_Deja_Denfendu2()
{
	if [[ "$Deja_Defendu2" != "Non" ]];
	then
		echo "Le joueur 2 a déjà tenté de parer et ne peut plus se défendre"
		Degat_Flat1
	fi		
}


#Relance_Match()
#{
#	if [[ "$Nombre_Match" -gt 0 ]];
#	then
#		echo " "
#		echo " ----- MATCH RESTANT -- $Nombre_Match ----- "
#		echo " "
#		Reinitialisation_Carac_New_Match
#		Who_start_fight
#	else
#		echo " "
#		echo " ----- SIMULATION TERMINEE ----- "
#		echo " "
#		Statistique
#	fi
#}

Statistique()
{
	Ave_Dgt_Evite_Match1=$((Nombre_Degat_Dodge1 / Nombre_Match_Total))
	Ave_Dgt_Reel_Evite_Match2=$((Nombre_Degat_Reel_Pare2 / Nombre_Match_Total))
	Ave_Pv_Restant_Match1=$((PV_Restant_Total1 / Nombre_Match_Total))
	Ave_Pv_Restant_Match2=$((PV_Restant_Total2 / Nombre_Match_Total))
	touch statistique.txt
	echo "#|Joueur 1 (Esquive)|Joueur 2 (Parade)" > statistique.txt
	echo "ATT Réussies|$Nombre_Touch_Reussie1|$Nombre_Touch_Reussie2" >> statistique.txt
	echo "ATT Failed|$Nombre_Touch_Failed1|$Nombre_Touch_Failed2" >> statistique.txt
	echo "DEF Tentées |$Nombre_Esq_Tente1|#" >> statistique.txt
	echo "DEF Réussies|$Nombre_Esq_Reussie1|$Nombre_Par_Reussie2" >> statistique.txt
	echo "DEF Failed|$Nombre_Esq_Failed1|$Nombre_Par_Failed2" >> statistique.txt
	echo "Dégâts Potentiels infligés|$Nombre_Degat_Potentiel1|$Nombre_Degat_Potentiel2" >> statistique.txt
	echo "Dégâts Réels infligés|$Nombre_Degat_Reel1|$Nombre_Degat_Reel2" >> statistique.txt
	echo "Réduction dégâts unique|$Degat_Flat_By_J2|$Reduc_Degat2" >> statistique.txt
	echo "Réduction dégâts totaux|$Nombre_Degat_Dodge1|$Nombre_Degat_Reel_Pare2" >> statistique.txt
	echo "Moyenne réduction dégâts / match|$Ave_Dgt_Evite_Match1|$Ave_Dgt_Reel_Evite_Match2" >> statistique.txt
	echo "Pv restants cumulés fin match|$PV_Restant_Total1|$PV_Restant_Total2" >> statistique.txt
	echo "Moyenne Pv restants / match|$Ave_Pv_Restant_Match1|$Ave_Pv_Restant_Match2" >> statistique.txt
	echo "Nombre Victoires|$Victoire1|$Victoire2" >> statistique.txt
	
	echo " "
	column statistique.txt -t -s "|"
	echo " "
	exit 0

}

##############
#### MAIN ####
##############

#Lancement du script appelant les premières fonctions qui appelleront d'autres fonctions, etc.
for ((i=0; i<Nombre_Match_Total; i++)); do
	Display_Round
	Who_start_fight
	Reinitialisation_Carac_New_Match
  
  
 done
echo " "
echo " ----- SIMULATION TERMINEE ----- "
echo " "

Statistique
