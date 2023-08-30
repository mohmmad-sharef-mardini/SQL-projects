/*  Cleaning Data in SQL Queries */

use portfolio ;
select count(*) from NashvilleHousing ;




--------------------------------------------------------------------------------------------------------------------------
--* Standardize Date Format *--

--*UniqueID*--
alter table NashvilleHousing alter column UniqueID int  ;

--*SaleDate*--

Select  CONVERT(Date,SaleDate)From NashvilleHousing ;

alter table NashvilleHousing alter column SaleDate date ;



--------------------------------------------------------------------------------------------------------------------------

--* fill null value in PropertyAddress *--

select PropertyAddress  from NashvilleHousing where PropertyAddress is null


--- There is corrleation between PropertyAddress and ParcelID---

select na1.UniqueID ,na1.ParcelID,na1.PropertyAddress,na2.ParcelID,na2.PropertyAddress 
from NashvilleHousing na1 
join NashvilleHousing na2 on na1.ParcelID = na2.ParcelID and na1.UniqueID != na2.UniqueID
where na1.PropertyAddress is null ;



select isnull(na1.PropertyAddress,na2.PropertyAddress )
from NashvilleHousing na1 
join NashvilleHousing na2 on na1.ParcelID = na2.ParcelID and na1.UniqueID != na2.UniqueID
where na1.PropertyAddress is null ;



--- Replace Null Value ---


update na1
set na1.PropertyAddress=isnull(na1.PropertyAddress,na2.PropertyAddress )
from NashvilleHousing na1 
join NashvilleHousing na2 on na1.ParcelID = na2.ParcelID and na1.UniqueID != na2.UniqueID
where na1.PropertyAddress is null ;

select PropertyAddress from NashvilleHousing where PropertyAddress is null ;




--------------------------------------------------------------------------------------------------------------------------




/* Split Up PropertyAddress */



select PropertyAddress, SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) ,substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN(PropertyAddress)) from NashvilleHousing


-- add columns to tabel --

alter table NashvilleHousing add  Property_Address nvarchar(255) ;
alter table NashvilleHousing add  Property_city  nvarchar(255) ;


---   Add Value  To Columns   ---



update NashvilleHousing 
set Property_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)from NashvilleHousing 

update NashvilleHousing 
set Property_Address = substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN(PropertyAddress))from NashvilleHousing 



--- remove PropertyAddress column 

alter table NashvilleHousing drop column PropertyAddress

--------------------------------------------------------------------------------------------------------------------------

---*   Split Out Address In OwnerAddress Column   *---


select OwnerAddress from NashvilleHousing ;


select OwnerAddress ,parsename(replace(OwnerAddress,',','.'),3),parsename(replace(OwnerAddress,',','.'),2),parsename(replace(OwnerAddress,',','.'),1) from NashvilleHousing 




--- add coulumns 
alter table NashvilleHousing 
add Owner_Address nvarchar(255) ;

alter table NashvilleHousing 
add Owner_city nvarchar(255) ;

alter table NashvilleHousing 
add Owner_state nvarchar(255) ;


--- insert data to news columns



update NashvilleHousing 
set Owner_Address =parsename(replace(OwnerAddress,',','.'),3);


update NashvilleHousing 
set Owner_city =parsename(replace(OwnerAddress,',','.'),2);

update NashvilleHousing 
set Owner_state =parsename(replace(OwnerAddress,',','.'),1);

-- remove old column 

alter table NashvilleHousing drop column OwnerAddress ;




--------------------------------------------------------------------------------------------------------------------------

---*  Replace y And n to Yes And No *---

select SoldAsVacant from NashvilleHousing group by SoldAsVacant ;

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='N' then 'No'
						when SoldAsVacant='Y' then 'Yes'
						else SoldAsVacant 
						end

---* Checking It Up  *---


--------------------------------------------------------------------------------------------------------------------------



---* Remove Duplicates *---

--- Find Out If We Have Duplicates --- 

with new11 as(select ParcelID,Property_Address,LegalReference,OwnerName,BuildingValue from NashvilleHousing )

select ParcelID,Property_Address,LegalReference,OwnerName,BuildingValue ,count(*)
from new11 
group by ParcelID,Property_Address,LegalReference,OwnerName,ParcelID,BuildingValue
having count(*)>1 ;




---*   Another Way To Find Out Duplicates   *---
with new22 as(
select *,ROW_NUMBER() over(partition by ParcelID,Property_Address,LegalReference,OwnerName,BuildingValue order by UniqueID ) num_row
from NashvilleHousing
--order by num_row desc 
)
delete  from new22 where num_row >1 ;

select count(*) from NashvilleHousing ;


