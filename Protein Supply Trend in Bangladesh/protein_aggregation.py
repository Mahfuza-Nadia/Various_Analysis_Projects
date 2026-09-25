import pandas as pd
from pathlib import Path


# ============================================================
# 1. LOAD THE ORIGINAL DATA
# ============================================================

src = Path("/mnt/data/files/worksheet.csv")
df = pd.read_csv(src)


# ============================================================
# 2. DEFINE THE SIX FOOD GROUPS
# ============================================================

fish = {
    "Freshwater Fish",
    "Demersal Fish",
    "Pelagic Fish",
    "Marine Fish, Other",
    "Crustaceans",
    "Cephalopods",
    "Molluscs, Other",
    "Aquatic Animals, Others",
    "Aquatic Products, Other",
    "Meat, Aquatic Mammals"
}

meat = {
    "Bovine Meat",
    "Mutton & Goat Meat",
    "Poultry Meat",
    "Meat, Other"
}

milk = {
    "Milk - Excluding Butter"
}

eggs = {
    "Eggs"
}

pulses = {
    "Beans",
    "Peas",
    "Pulses, Other and products"
}

cereals = {
    "Rice and products",
    "Wheat and products",
    "Barley and products",
    "Maize and products",
    "Rye and products",
    "Oats",
    "Millet and products",
    "Sorghum and products",
    "Cereals, other"
}


# ============================================================
# 3. ASSIGN EACH ITEM TO A FOOD GROUP
# ============================================================

category_sets = {
    "Fish": fish,
    "Meat": meat,
    "Milk": milk,
    "Eggs": eggs,
    "Pulses": pulses,
    "Cereals": cereals
}

item_to_category = {
    item: category
    for category, items in category_sets.items()
    for item in items
}


# ============================================================
# 4. KEEP ONLY THE SELECTED FOOD ITEMS
# ============================================================

included = df[df["Item"].isin(item_to_category)].copy()

included["Six_Category"] = included["Item"].map(item_to_category)


# ============================================================
# 5. REMOVE AGGREGATE ROWS TO AVOID DOUBLE COUNTING
# ============================================================

excluded_aggregates = {
    "Fish, Seafood",
    "Meat",
    "Pulses",
    "Cereals - Excluding Beer"
}

included = included[
    ~included["Item"].isin(excluded_aggregates)
].copy()


# ============================================================
# 6. KEEP THE IMPORTANT ORIGINAL COLUMNS
# ============================================================

included = included[
    [
        "Element",
        "Item",
        "Six_Category",
        "Year",
        "Unit",
        "Value",
        "Note"
    ]
]


# ============================================================
# 7. SUM PROTEIN BY FOOD GROUP AND YEAR
# ============================================================

by_year = (
    included
    .groupby(
        ["Year", "Six_Category"],
        as_index=False
    )["Value"]
    .sum()
    .pivot(
        index="Year",
        columns="Six_Category",
        values="Value"
    )
    .reindex(
        columns=[
            "Fish",
            "Meat",
            "Milk",
            "Eggs",
            "Pulses",
            "Cereals"
        ]
    )
    .reset_index()
)


# Replace missing values with zero
by_year[
    [
        "Fish",
        "Meat",
        "Milk",
        "Eggs",
        "Pulses",
        "Cereals"
    ]
] = by_year[
    [
        "Fish",
        "Meat",
        "Milk",
        "Eggs",
        "Pulses",
        "Cereals"
    ]
].fillna(0)


# ============================================================
# 8. CREATE AN AUDIT TABLE
# ============================================================

item_audit = (
    included[
        ["Item", "Six_Category"]
    ]
    .drop_duplicates()
    .sort_values(
        ["Six_Category", "Item"]
    )
)


# ============================================================
# 9. SAVE THE RESULTS TO EXCEL
# ============================================================

out = Path(
    "/mnt/data/six_food_groups_component_grouped.xlsx"
)

with pd.ExcelWriter(
    out,
    engine="openpyxl"
) as writer:

    included.to_excel(
        writer,
        sheet_name="Classified_Items",
        index=False
    )

    by_year.to_excel(
        writer,
        sheet_name="Six_Groups_By_Year",
        index=False
    )

    item_audit.to_excel(
        writer,
        sheet_name="Item_Classification",
        index=False
    )


# ============================================================
# 10. DISPLAY RESULTS
# ============================================================

print("Created:", out)

print("Original rows:", len(df))

print(
    "Classified rows retained:",
    len(included)
)

print(
    "Unique classified items:",
    included["Item"].nunique()
)

print("\nItems classified:")
print(item_audit.to_string(index=False))

print("\nYearly grouped values:")
print(by_year.to_string(index=False))