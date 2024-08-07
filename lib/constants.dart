library constants;

import 'package:flutter/material.dart';

const String APP_NAME = 'Er ríkið opið?';

const String STORE_DATA_URL =
    'https://www.vinbudin.is/addons/origo/module/ajaxwebservices/search.asmx/GetAllShops';
const String STORE_WEBSITE_URL = 'https://www.vinbudin.is';

const Locale DEFAULT_LOCALE = Locale('is', 'IS');

// TODO: Turn these into user-configurable options.
const bool HIDE_CLOSED = false;
const bool HIDE_UNLOCATED = true;

// Constants for development purposes.
const bool DEV_USE_LOCAL_JSON = false;
