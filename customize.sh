set_permissions() {
  set_perm  $MODPATH/system/vendor/etc/thermal-arvr.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-engine.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-extreme.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-high.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-map.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-nolimits.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-normal.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/etc/thermal-tgame.conf       0       0       0644
  set_perm  $MODPATH/system/vendor/bin/perf_profile.sh       0       0       0755
  set_perm  $MODPATH/system/vendor/bin/restore_perf_profile.sh       0       0       0755
}

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
