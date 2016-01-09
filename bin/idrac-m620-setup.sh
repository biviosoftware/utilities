#!/bin/bash

ra() {
    local slot=$1
    shift
    local ip=${RA_BASE_IP%.*}.$((${RA_BASE_IP##*.} + $slot))
    local cmd=( $@ )
    if [[ ${cmd[0]} = job ]]; then
	cmd=( jobqueue create "${cmd[1]}" -r pwrcycle -s TIME_NOW -e TIME_NA )
    fi
    idracadm7 -r "$ip" -u root -p "$RA_PASSWORD" "${cmd[@]}" \
        | egrep -v '^(Security Alert: Certificate|Continuing execution. Use -S)'
}

ra_all() {
    local s
    local c
    for s in "${RA_ALL_SLOTS[@]}"; do
	echo "blade: $s"
        for c in "$@"; do
	    ra "$s" $c
        done
    done
}

ra_serial_comm_settings() {
    ra_all 'set BIOS.SerialCommSettings.ConTermType Vt100Vt220' \
	'set BIOS.SerialCommSettings.RedirAfterBoot Enabled' \
	'set BIOS.SerialCommSettings.SerialPortAddress Com1' \
	'set BIOS.SerialCommSettings.SerialComm OnConRedir' \
	'set BIOS.SerialCommSettings.FailSafeBaud 115200' \
	'job BIOS.Setup.1-1'
}

ra_raid_resetconfig() {
    ra_all 'storage resetconfig:RAID.Integrated.1-1' \
        'job RAID.Integrated.1-1'
}

ra_raid_jbod() {
    # We know all blades are configured identically:
    local p
    local cmds=()
    local c='raid createvd:RAID.Integrated.1-1 -rl r0 -wp wt -rp nra -ss 64k -pdkey:'
    for p in $(ra "${RA_ALL_SLOTS[0]}" storage get pdisks | tr -d '\r\n'); do
        cmds+=( "$c$p" )
    done
    ra_all "${cmds[@]}" \
        'job RAID.Integrated.1-1'
}

ra_boot_settings() {
    ra_all 'set BIOS.BiosBootSettings.BootSeq HardDisk.List.1-1' \
        'set BIOS.BiosBootSettings.HddSeq RAID.Integrated.1-1' \
	'job BIOS.Setup.1-1'
}
