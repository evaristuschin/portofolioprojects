
--Standardize Date Formate

SELECT saleDate , CONVERT(Date,saleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing 
SET saleDate = CONVERT(Date , saleDate)

alter table NashvilleHousing
alter column saleDate Date


-- populate prperty address data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--where propertyAddress is null
order by parcelID




SELECT p.parcelID ,p.PropertyAddress ,b.ParcelID ,b.PropertyAddress, isnull(p.PropertyAddress,b.propertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing p
join PortfolioProject.dbo.NashvilleHousing b
 on p.parcelID = b.parcelID 
 and p.[UniqueID ] <> b.[UniqueID ]
 where p.PropertyAddress is null 


 update p
 set PropertyAddress = isnull(p.PropertyAddress,b.propertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing p
join PortfolioProject.dbo.NashvilleHousing b
 on p.parcelID = b.parcelID 
 and p.[UniqueID ] <> b.[UniqueID ]
 where p.PropertyAddress is null 


 -- Breaking out Address into into individual colums ( Address ,City ,State )

 
SELECT PropertyAddress 
FROM PortfolioProject.dbo.NashvilleHousing
--where propertyAddress is null
--order by parcelID

select
substring (PropertyAddress ,1 ,CHARINDEX(',',PropertyAddress ) -1) as Address,
substring (PropertyAddress ,CHARINDEX(',',PropertyAddress ) +1 ,len(PropertyAddress)) as Address  


FROM PortfolioProject.dbo.NashvilleHousing
 
 
alter table NashvilleHousing
add PropertysplitAddress  nvarchar(255)

Update NashvilleHousing 
SET PropertysplitAddress =substring (PropertyAddress ,1 ,CHARINDEX(',',PropertyAddress ) -1) 


alter table NashvilleHousing
add Propertysplitcity nvarchar(255)

Update NashvilleHousing 
SET Propertysplitcity = substring (PropertyAddress ,CHARINDEX(',',PropertyAddress ) +1 ,len(PropertyAddress)) 

--owner address 

select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing
 
 select
 PARSENAME(replace(OwnerAddress,',','.'),3),
  PARSENAME(replace(OwnerAddress,',','.'),2),
   PARSENAME(replace(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing
 

 
 
alter table NashvilleHousing
add OwnersplitAddress  nvarchar(255)

Update NashvilleHousing 
SET OwnersplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)



alter table NashvilleHousing
add ownersplitcity nvarchar(255)

Update NashvilleHousing 
SET Ownersplitcity =   PARSENAME(replace(OwnerAddress,',','.'),2)



alter table NashvilleHousing
add ownersplitstate nvarchar(255)

Update NashvilleHousing 
SET Ownersplitstate =   PARSENAME(replace(OwnerAddress,',','.'),1)


--changeing sold as vacant field 

select distinct (SoldAsVacant),count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
   when SoldAsVacant = 'N'  then 'No'
   else SoldAsVacant
   end 
FROM PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes'
   when SoldAsVacant = 'N'  then 'No'
   else SoldAsVacant
   end 


   --remove duplicates 
with RowNumCTE as (
   select * ,
   ROW_NUMBER() over (
   partition by parcelID,
                SalePrice,
				SaleDate,
				LegalReference
				order by
				   UniqueID) row_num  
   FROM PortfolioProject.dbo.NashvilleHousing
   )
   select *
   from RowNumCTE 
   where row_num > 1



   --delect unused colums

   select *
    FROM PortfolioProject.dbo.NashvilleHousing

	alter table PortfolioProject.dbo.NashvilleHousing
	drop column OwnerAddress ,TaxDistrict , PropertyAddress 
