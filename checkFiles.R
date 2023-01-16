
# check files for 3d fusion

filePwd = '/Users/jiabao/Documents/1_github/fusion3dviewerTest/www/Fusion_PDB'

fileInPwd = list.files(filePwd)

length(fileInPwd)

pdbFileList = fileInPwd[grep('pdb', fileInPwd)]
svgFileList = fileInPwd[grep('svg|SVG', fileInPwd)]

length(pdbFileList)
length(svgFileList)

myRmSuffix = function(x){
  return(substr(x, 1, nchar(x)-4))
}

pdbFileRemoveSuffix = unlist(lapply(pdbFileList, myRmSuffix))
svgFileRemoveSuffix = unlist(lapply(svgFileList, myRmSuffix))

pdbFileDf = data.frame(pdbFile = pdbFileList,
                       name = pdbFileRemoveSuffix)
svgFileDf = data.frame(svgFile = svgFileList,
                       name = svgFileRemoveSuffix)

pdbSvgMergeDf = merge(pdbFileDf, svgFileDf, all = T)

pdbSvgMergeDfNaFile = pdbSvgMergeDf[which(apply(is.na(pdbSvgMergeDf), 1, sum)==1),]

pdbSvgMergeDfNona = na.omit(pdbSvgMergeDf)
write.csv(pdbSvgMergeDfNona, file = 'pdbSvgMergeDfNona.csv', row.names = F)

