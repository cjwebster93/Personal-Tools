$listdisks = Get-PSDrive C | Select-Object Used,Free
($listdisks.Free / 1GB).ToDecimal()