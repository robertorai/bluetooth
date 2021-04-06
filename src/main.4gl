IMPORT util

IMPORT JAVA java.lang.Runtime
IMPORT JAVA java.util.Iterator
IMPORT JAVA java.lang.Class
IMPORT JAVA java.lang.Math

IMPORT JAVA android.bluetooth.BluetoothAdapter
IMPORT JAVA android.bluetooth.BluetoothDevice
IMPORT JAVA android.content.Context
IMPORT JAVA android.os.Build
IMPORT JAVA android.util.DisplayMetrics
IMPORT JAVA android.view.WindowManager

IMPORT JAVA com.fourjs.gma.vm.FglRun

MAIN
	MENU "Samples"
		COMMAND "Android API access"
			CALL androidApiAccess()
		COMMAND "Quit"
			EXIT MENU
		ON ACTION close
			EXIT MENU
	END MENU
END MAIN

FUNCTION androidApiAccess()
	MENU "Android API access"
		COMMAND "Accessing Java standard API"
			CALL androidApiAccess_java_standard()
		COMMAND "Accessing simple android information"
			CALL androidApiAccess_android_simple()
		COMMAND "Accessing sophisticated APIs : bluetooth"
			CALL androidApiAccess_bluetooth()
		ON ACTION CANCEL
			EXIT MENU
	END MENU
END FUNCTION

FUNCTION androidApiAccess_java_standard()
	DEFINE r Runtime

	OPEN WINDOW w WITH FORM "formJavaStandard"

	LET r = java.lang.Runtime.getRuntime()
	DISPLAY r.availableProcessors() TO nb_proc

	MENU
		ON ACTION QUIT
			EXIT MENU
		ON ACTION close
			EXIT MENU
	END MENU

	CLOSE WINDOW w
END FUNCTION

FUNCTION androidApiAccess_android_simple()
	DEFINE s STRING
	DEFINE dm DisplayMetrics
	DEFINE c Context
	DEFINE width, height, dens, wi, hi, x, y FLOAT
	DEFINE screenInches FLOAT
	DEFINE wm android.view.WindowManager

	OPEN WINDOW w WITH FORM "formAndroidSimple"

	LET s = android.os.Build.MANUFACTURER
	DISPLAY s TO manufacturer
	LET s = android.os.Build.MODEL
	DISPLAY s TO model
	LET s = android.os.Build.SERIAL
	DISPLAY s TO serial

	# Get the FglRun Context
	LET c = com.fourjs.gma.vm.FglRun.getContext()

	# Compute display dimension (diagonal)
	LET dm = android.util.DisplayMetrics.create()
	LET wm = CAST ( c.getSystemService("window") AS android.view.WindowManager )
	CALL wm.getDefaultDisplay().getMetrics(dm)
	LET width = dm.widthPixels
	LET height = dm.heightPixels
	LET dens = dm.densityDpi
	LET wi = width/dens
	LET hi = height/dens
	LET x = util.Math.pow(wi,2)
	LET y = util.Math.pow(hi,2);
	LET screenInches = util.Math.sqrt(x+y);

	DISPLAY screenInches TO diagonal
	MENU
		ON ACTION QUIT
			EXIT MENU
		ON ACTION close
			EXIT MENU
	END MENU

	CLOSE WINDOW w
END FUNCTION

FUNCTION androidApiAccess_bluetooth()
	DEFINE ba  BluetoothAdapter
	DEFINE sbd Iterator
	DEFINE bd  BluetoothDevice
	DEFINE bds DYNAMIC ARRAY OF RECORD
		name STRING,
		comment STRING
	END RECORD
	DEFINE i INTEGER
	DEFINE s STRING

	OPEN WINDOW w WITH FORM "formAndroidBluetooth"

	LET ba = android.bluetooth.BluetoothAdapter.getDefaultAdapter()
	LET s = ba.getName()
	DISPLAY s TO ba_name

	LET sbd = ba.getBondedDevices().iterator()
	LET i = 0
	WHILE sbd.hasNext()
		LET bd = CAST(sbd.next() AS BluetoothDevice)
		LET i = i + 1
		LET bds[i].name = bd.getName()
		LET bds[i].comment = bd.getBluetoothClass().toString()
	END WHILE

	DISPLAY ARRAY bds TO list.*
		ON ACTION QUIT
			EXIT DISPLAY
		ON ACTION close
			EXIT DISPLAY
	END DISPLAY

	CLOSE WINDOW w
END FUNCTION
