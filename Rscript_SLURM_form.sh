#!/bin/bash
## Give a name to  your job
#SBATCH --job-name=R_job
## precise the logfile for your job
#SBATCH --output=R_job.out
## precise the error file for your job
#SBATCH --error=R_job_err.out
# Precise the partion you want to use
#SBATCH --partition=normal
# precise when you receive the email
#SBATCH --mail-type=end
# precise to  which address you have to send the mail to
#SBATCH --mail-user=ngan.phan-thi@ird.fr
# number of cpu you want to use on you node
#SBATCH --cpus-per-task=2

############################################################
path_to_dir="/projects/medium/graminicola_evolution/ISOLATES"
path_to_tmp="/scratch/R_jobs_NP"
path_to_dest="/projects/medium/graminicola_evolution/ISOLATES/CNV"


############# chargement du module load CNVnator
module load R/



###### Creation du repertoire temporaire sur  la partition /scratch du noeud
mkdir $path_to_tmp
cd $path_to_tmp

####### copie du repertoire de données  vers la partition /scratch du noeud

scp $path_to_dir/ $path_to_tmp/
echo "tranfert donnees master -> noeud"

###### Execution du programme
# Run the R script
Rscript my_script.R




############################################################### my_script.R #############################################################################################
##   
###INSTALL R package if needed

# Specify a personal library (if you don't have write access to system libraries)
lib_path <- "~/Rlibs"
dir.create(lib_path, showWarnings = FALSE, recursive = TRUE)
.libPaths(lib_path)

# Install packages if not already installed
packages <- c("ggplot2", "dplyr")
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "https://cran.r-project.org", lib = lib_path)
    library(pkg, character.only = TRUE)
  }
}



# Load installed packages
library(ggplot2)
library(dplyr)


###export table
#write.csv(my_data, file = "output_table.csv", row.names = FALSE)

#write.table(my_data, file = "output_table.tsv", sep = "\t", row.names = FALSE, quote = FALSE)

# export excel
install.packages("writexl", repos = "https://cran.r-project.org")
library(writexl)

write_xlsx(my_data, path = "output_table.xlsx")

#export png
png("output_plot.png", width = 800, height = 600)
plot(1:10, rnorm(10), main = "Example Plot")
dev.off()

#export pdf
pdf("output_plot.pdf", width = 8, height = 6)
plot(1:10, rnorm(10), main = "Example Plot")
dev.off()

#export jpeg
jpeg("output_plot.jpg", width = 800, height = 600, quality = 90)
plot(1:10, rnorm(10), main = "Example Plot")
dev.off()

#save ggplot plot
library(ggplot2)
p <- ggplot(mtcars, aes(x = mpg, y = hp)) + geom_point()
ggsave("output_ggplot.png", plot = p, width = 8, height = 6, dpi = 300)

###################################################end my_script.R#########################################################################################################

###transfert des donnes du noeud vers master

scp -rp $path_to_tmp  $path_to_dest/
echo "Transfert donnees node -> master"

#### Suppression du repertoire tmp noeud
rm -rf $path_to_tmp
echo "Suppression des donnees sur le noeud"


