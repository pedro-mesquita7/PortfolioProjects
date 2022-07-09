SELECT *
FROM PortfolioProject..nashville_housing

-- Standardize Date Format
SELECT SaleDate, CONVERT(date,SaleDate)
FROM PortfolioProject..nashville_housing

ALTER TABLE nashville_housing
ADD sale_date_converted Date;

UPDATE nashville_housing
SET sale_date_converted = CONVERT(date, SaleDate)

-- Populate Property Adress Date
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..nashville_housing AS a
JOIN PortfolioProject..nashville_housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..nashville_housing AS a
JOIN PortfolioProject..nashville_housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--  Breaking out adress into individual columns (adress, city, state)
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Adress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM PortfolioProject..nashville_housing

ALTER TABLE nashville_housing
ADD property_split_adress nvarchar(255);

UPDATE nashville_housing
SET property_split_adress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE nashville_housing
ADD property_city_adress nvarchar(255);

UPDATE nashville_housing
SET property_city_adress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-- 

SELECT 
	PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
	PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
	PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..nashville_housing

ALTER TABLE nashville_housing
ADD owner_split_adress nvarchar(255);

UPDATE nashville_housing
SET owner_split_adress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE nashville_housing
ADD owner_split_city nvarchar(255);

UPDATE nashville_housing
SET owner_split_city = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE nashville_housing
ADD owner_split_state nvarchar(255);

UPDATE nashville_housing
SET owner_split_state = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


-- Change Y and N to Yes and No in 'Sold as Vacant' field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..nashville_housing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProject..nashville_housing

UPDATE nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject..nashville_housing
--order by ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns

SELECT *
FROM PortfolioProject..nashville_housing

ALTER TABLE PortfolioProject..nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate