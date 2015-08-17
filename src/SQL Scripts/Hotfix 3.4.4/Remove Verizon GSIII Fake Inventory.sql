USE [CarToys]

DELETE FROM catalog.[GersStock]
WHERE GersSku IN (
	'VGXYS3B16'
	,'VGXYS3B32'
	,'VGXYS3W16'
	,'VGXYS3W32')
	AND OrderDetailID IS NULL
	AND OutletCode = 'FAK'

