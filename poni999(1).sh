#!/bin/bash

url=$1

# Check if the main directory exists, if not, create it
if [ ! -d "$url" ]; then
    mkdir "$url"
fi

# Check if the recon directory exists, if not, create it
if [ ! -d "$url/recon" ]; then
    mkdir "$url/recon"
fi

# Check if the final directory exists, if not, create it
if [ ! -d "$url/recon/final" ]; then
    mkdir "$url/recon/final"
fi

# Navigate to the recon directory
cd "$url/recon" || exit

# Print message indicating the start of subdomain enumeration
echo "[+] Starting to passively enumerate subdomains for $url"

# Print message indicating the use of Sublist3r
echo "[+] Enumerating subdomains with Sublist3r..."
sublist3r -d "$url" >> "sublist3r.txt"
echo "[+] Sublist3r output saved to: $PWD/sublist3r.txt"


# Print message indicating the use of Amass
echo "[+] Enumerating subdomains with Amass..."

# Command to run Amass - Commented out for now
amass enum -d "$url" >> Amass.txt
touch Amass.txt

echo "[+] enumarating with theHarvester"

#run the tool the Harvester 
theHarvester -d "$url" -b all -l 50 > "theharvester.txt"
echo "[+] TheHarvester output saved to: $PWD/theharvester.txt"


echo "[+] Enumerating subdomains with AssetFinder..."


# Print message indicating the use of AssetFinder
echo "[+] Enumerating subdomains with AssetFinder..."


# Run AssetFinder and save the output to assetfinder.txt
assetfinder -subs-only "$url" > assetfinder.txt
echo "[+] AssetFinder output saved to: $PWD/assetfinder.txt"

# Print message indicating the use of HttProbe
echo "[+] Performing HTTP probing..."
cat sublist3r.txt Amass.txt theharvester.txt assetfinder.txt | httprobe >> "httprobe.txt"
echo "[+] HttProbe output saved to: $PWD/httprobe.txt"




# Append AssetFinder output to the final subdomain file
cat assetfinder.txt >> final/final.txt

#location of the file saved to :
echo "[+] Combined AssetFinder output saved to: $PWD/final/final.txt"

# Concatenate all subdomain files into one and remove duplicates
cat Amass.txt assetfinder.txt | sort -u > subdomains

echo "[+] Combined subdomains saved to: $PWD/subdomains"
