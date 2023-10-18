CONCAT(
FLOOR(item.duration / 3600).toString().padStart(2, "0"),
":",
FLOOR((item.duration / 60) % 60).toString().padStart(2, "0"),
":",
ROUND(item.duration % 60).toString().padStart(2, "0")
)

CONCAT(FLOOR(item.duration / 60).toString().padStart(2, "0"), ":", ROUND(item.duration % 60).toString().padStart(2, "0"))