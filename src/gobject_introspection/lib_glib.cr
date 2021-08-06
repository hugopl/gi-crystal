@[Link("gobject-2.0", pkg_config: "gobject-2.0")]
@[Link("glib-2.0", pkg_config: "glib-2.0")]
lib LibGLib
  ###########################################
  ##    Constants
  ###########################################
  ANALYZER_ANALYZING = 1 # : Int32
  ASCII_DTOSTR_BUF_SIZE = 39 # : Int32
  BIG_ENDIAN = 4321 # : Int32
  CSET_A_2_Z = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" # : Pointer(UInt8)
  CSET_DIGITS = "0123456789" # : Pointer(UInt8)
  CSET_a_2_z = "abcdefghijklmnopqrstuvwxyz" # : Pointer(UInt8)
  DATALIST_FLAGS_MASK = 3 # : Int32
  DATE_BAD_DAY = 0 # : Int32
  DATE_BAD_JULIAN = 0 # : Int32
  DATE_BAD_YEAR = 0 # : Int32
  DIR_SEPARATOR = 47 # : Int32
  DIR_SEPARATOR_S = "/" # : Pointer(UInt8)
  E = 2.718282 # : Float64
  GINT16_FORMAT = "hi" # : Pointer(UInt8)
  GINT16_MODIFIER = "h" # : Pointer(UInt8)
  GINT32_FORMAT = "i" # : Pointer(UInt8)
  GINT32_MODIFIER = "" # : Pointer(UInt8)
  GINT64_FORMAT = "li" # : Pointer(UInt8)
  GINT64_MODIFIER = "l" # : Pointer(UInt8)
  GINTPTR_FORMAT = "li" # : Pointer(UInt8)
  GINTPTR_MODIFIER = "l" # : Pointer(UInt8)
  GNUC_FUNCTION = "" # : Pointer(UInt8)
  GNUC_PRETTY_FUNCTION = "" # : Pointer(UInt8)
  GSIZE_FORMAT = "lu" # : Pointer(UInt8)
  GSIZE_MODIFIER = "l" # : Pointer(UInt8)
  GSSIZE_FORMAT = "li" # : Pointer(UInt8)
  GSSIZE_MODIFIER = "l" # : Pointer(UInt8)
  GUINT16_FORMAT = "hu" # : Pointer(UInt8)
  GUINT32_FORMAT = "u" # : Pointer(UInt8)
  GUINT64_FORMAT = "lu" # : Pointer(UInt8)
  GUINTPTR_FORMAT = "lu" # : Pointer(UInt8)
  HAVE_GINT64 = 1 # : Int32
  HAVE_GNUC_VARARGS = 1 # : Int32
  HAVE_GNUC_VISIBILITY = 1 # : Int32
  HAVE_GROWING_STACK = 0 # : Int32
  HAVE_ISO_VARARGS = 1 # : Int32
  HOOK_FLAG_USER_SHIFT = 4 # : Int32
  IEEE754_DOUBLE_BIAS = 1023 # : Int32
  IEEE754_FLOAT_BIAS = 127 # : Int32
  KEY_FILE_DESKTOP_GROUP = "Desktop Entry" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_ACTIONS = "Actions" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_CATEGORIES = "Categories" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_COMMENT = "Comment" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_DBUS_ACTIVATABLE = "DBusActivatable" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_EXEC = "Exec" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_GENERIC_NAME = "GenericName" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_HIDDEN = "Hidden" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_ICON = "Icon" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_MIME_TYPE = "MimeType" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_NAME = "Name" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_NOT_SHOW_IN = "NotShowIn" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_NO_DISPLAY = "NoDisplay" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_ONLY_SHOW_IN = "OnlyShowIn" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_PATH = "Path" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_STARTUP_NOTIFY = "StartupNotify" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_STARTUP_WM_CLASS = "StartupWMClass" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_TERMINAL = "Terminal" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_TRY_EXEC = "TryExec" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_TYPE = "Type" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_URL = "URL" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_KEY_VERSION = "Version" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_TYPE_APPLICATION = "Application" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_TYPE_DIRECTORY = "Directory" # : Pointer(UInt8)
  KEY_FILE_DESKTOP_TYPE_LINK = "Link" # : Pointer(UInt8)
  LITTLE_ENDIAN = 1234 # : Int32
  LN10 = 2.302585 # : Float64
  LN2 = 0.693147 # : Float64
  LOG_2_BASE_10 = 0.30103 # : Float64
  LOG_DOMAIN = 0i8 # : Int8
  LOG_FATAL_MASK = 5 # : Int32
  LOG_LEVEL_USER_SHIFT = 8 # : Int32
  MAJOR_VERSION = 2 # : Int32
  MAXINT16 = 32767i16 # : Int16
  MAXINT32 = 2147483647 # : Int32
  MAXINT64 = 9223372036854775807i64 # : Int64
  MAXINT8 = 127i8 # : Int8
  MAXUINT16 = 65535u16 # : UInt16
  MAXUINT32 = 4294967295 # : UInt32
  MAXUINT64 = 18446744073709551615u64 # : UInt64
  MAXUINT8 = 255u8 # : UInt8
  MICRO_VERSION = 0 # : Int32
  MININT16 = -32768i16 # : Int16
  MININT32 = -2147483648 # : Int32
  MININT64 = -9223372036854775808i64 # : Int64
  MININT8 = -128i8 # : Int8
  MINOR_VERSION = 68 # : Int32
  MODULE_SUFFIX = "so" # : Pointer(UInt8)
  OPTION_REMAINING = "" # : Pointer(UInt8)
  PDP_ENDIAN = 3412 # : Int32
  PI = 3.141593 # : Float64
  PID_FORMAT = "i" # : Pointer(UInt8)
  PI_2 = 1.570796 # : Float64
  PI_4 = 0.785398 # : Float64
  POLLFD_FORMAT = "%d" # : Pointer(UInt8)
  PRIORITY_DEFAULT = 0 # : Int32
  PRIORITY_DEFAULT_IDLE = 200 # : Int32
  PRIORITY_HIGH = -100 # : Int32
  PRIORITY_HIGH_IDLE = 100 # : Int32
  PRIORITY_LOW = 300 # : Int32
  SEARCHPATH_SEPARATOR = 58 # : Int32
  SEARCHPATH_SEPARATOR_S = ":" # : Pointer(UInt8)
  SIZEOF_LONG = 8 # : Int32
  SIZEOF_SIZE_T = 8 # : Int32
  SIZEOF_SSIZE_T = 8 # : Int32
  SIZEOF_VOID_P = 8 # : Int32
  SOURCE_CONTINUE = 1 # : LibC::Int
  SOURCE_REMOVE = 0 # : LibC::Int
  SQRT2 = 1.414214 # : Float64
  STR_DELIMITERS = "_-|> <." # : Pointer(UInt8)
  SYSDEF_AF_INET = 2 # : Int32
  SYSDEF_AF_INET6 = 10 # : Int32
  SYSDEF_AF_UNIX = 1 # : Int32
  SYSDEF_MSG_DONTROUTE = 4 # : Int32
  SYSDEF_MSG_OOB = 1 # : Int32
  SYSDEF_MSG_PEEK = 2 # : Int32
  TEST_OPTION_ISOLATE_DIRS = "isolate_dirs" # : Pointer(UInt8)
  TIME_SPAN_DAY = 86400000000i64 # : Int64
  TIME_SPAN_HOUR = 3600000000i64 # : Int64
  TIME_SPAN_MILLISECOND = 1000i64 # : Int64
  TIME_SPAN_MINUTE = 60000000i64 # : Int64
  TIME_SPAN_SECOND = 1000000i64 # : Int64
  UNICHAR_MAX_DECOMPOSITION_LENGTH = 18 # : Int32
  URI_RESERVED_CHARS_GENERIC_DELIMITERS = ":/?#[]@" # : Pointer(UInt8)
  URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS = "!$&'()*+,;=" # : Pointer(UInt8)
  USEC_PER_SEC = 1000000 # : Int32
  VA_COPY_AS_ARRAY = 1 # : Int32
  VERSION_MIN_REQUIRED = 2 # : Int32
  WIN32_MSG_HANDLE = 19981206 # : Int32

  ###########################################
  ##    Structs
  ###########################################

  struct Array # struct
    data : Pointer(UInt8)
    len : UInt32
  end
  fun g_array_get_type : UInt64

  struct AsyncQueue # struct
    _data : UInt8[0]
  end
  fun g_async_queue_length(this : AsyncQueue*) : Int32
  fun g_async_queue_length_unlocked(this : AsyncQueue*) : Int32
  fun g_async_queue_lock(this : AsyncQueue*) : Void
  fun g_async_queue_pop(this : AsyncQueue*) : Pointer(Void)
  fun g_async_queue_pop_unlocked(this : AsyncQueue*) : Pointer(Void)
  fun g_async_queue_push(this : AsyncQueue*, data : Pointer(Void)) : Void
  fun g_async_queue_push_front(this : AsyncQueue*, item : Pointer(Void)) : Void
  fun g_async_queue_push_front_unlocked(this : AsyncQueue*, item : Pointer(Void)) : Void
  fun g_async_queue_push_unlocked(this : AsyncQueue*, data : Pointer(Void)) : Void
  fun g_async_queue_ref_unlocked(this : AsyncQueue*) : Void
  fun g_async_queue_remove(this : AsyncQueue*, item : Pointer(Void)) : LibC::Int
  fun g_async_queue_remove_unlocked(this : AsyncQueue*, item : Pointer(Void)) : LibC::Int
  fun g_async_queue_timed_pop(this : AsyncQueue*, end_time : Pointer(LibGLib::TimeVal)) : Pointer(Void)
  fun g_async_queue_timed_pop_unlocked(this : AsyncQueue*, end_time : Pointer(LibGLib::TimeVal)) : Pointer(Void)
  fun g_async_queue_timeout_pop(this : AsyncQueue*, timeout : UInt64) : Pointer(Void)
  fun g_async_queue_timeout_pop_unlocked(this : AsyncQueue*, timeout : UInt64) : Pointer(Void)
  fun g_async_queue_try_pop(this : AsyncQueue*) : Pointer(Void)
  fun g_async_queue_try_pop_unlocked(this : AsyncQueue*) : Pointer(Void)
  fun g_async_queue_unlock(this : AsyncQueue*) : Void
  fun g_async_queue_unref(this : AsyncQueue*) : Void
  fun g_async_queue_unref_and_unlock(this : AsyncQueue*) : Void

  struct BookmarkFile # struct
    _data : UInt8[0]
  end
  fun g_bookmark_file_add_application(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), exec : Pointer(UInt8)) : Void
  fun g_bookmark_file_add_group(this : BookmarkFile*, uri : Pointer(UInt8), group : Pointer(UInt8)) : Void
  fun g_bookmark_file_free(this : BookmarkFile*) : Void
  fun g_bookmark_file_get_added(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Int64
  fun g_bookmark_file_get_added_date_time(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::DateTime)
  fun g_bookmark_file_get_app_info(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), exec : Pointer(UInt8)*, count : UInt32*, stamp : Int64*, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_get_application_info(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), exec : Pointer(UInt8)*, count : UInt32*, stamp : Pointer(LibGLib::DateTime)*, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_get_applications(this : BookmarkFile*, uri : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_bookmark_file_get_description(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_bookmark_file_get_groups(this : BookmarkFile*, uri : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_bookmark_file_get_icon(this : BookmarkFile*, uri : Pointer(UInt8), href : Pointer(UInt8)*, mime_type : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_get_is_private(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_get_mime_type(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_bookmark_file_get_modified(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Int64
  fun g_bookmark_file_get_modified_date_time(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::DateTime)
  fun g_bookmark_file_get_size(this : BookmarkFile*) : Int32
  fun g_bookmark_file_get_title(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_bookmark_file_get_uris(this : BookmarkFile*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_bookmark_file_get_visited(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Int64
  fun g_bookmark_file_get_visited_date_time(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::DateTime)
  fun g_bookmark_file_has_application(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_has_group(this : BookmarkFile*, uri : Pointer(UInt8), group : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_has_item(this : BookmarkFile*, uri : Pointer(UInt8)) : LibC::Int
  fun g_bookmark_file_load_from_data(this : BookmarkFile*, data : Pointer(UInt8), length : UInt64, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_load_from_data_dirs(this : BookmarkFile*, file : Pointer(UInt8), full_path : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_load_from_file(this : BookmarkFile*, filename : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_move_item(this : BookmarkFile*, old_uri : Pointer(UInt8), new_uri : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_remove_application(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_remove_group(this : BookmarkFile*, uri : Pointer(UInt8), group : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_remove_item(this : BookmarkFile*, uri : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_set_added(this : BookmarkFile*, uri : Pointer(UInt8), added : Int64) : Void
  fun g_bookmark_file_set_added_date_time(this : BookmarkFile*, uri : Pointer(UInt8), added : Pointer(LibGLib::DateTime)) : Void
  fun g_bookmark_file_set_app_info(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), exec : Pointer(UInt8), count : Int32, stamp : Int64, error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_set_application_info(this : BookmarkFile*, uri : Pointer(UInt8), name : Pointer(UInt8), exec : Pointer(UInt8), count : Int32, stamp : Pointer(LibGLib::DateTime), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_set_description(this : BookmarkFile*, uri : Pointer(UInt8), description : Pointer(UInt8)) : Void
  fun g_bookmark_file_set_groups(this : BookmarkFile*, uri : Pointer(UInt8), groups : Pointer(Pointer(UInt8)), length : UInt64) : Void
  fun g_bookmark_file_set_icon(this : BookmarkFile*, uri : Pointer(UInt8), href : Pointer(UInt8), mime_type : Pointer(UInt8)) : Void
  fun g_bookmark_file_set_is_private(this : BookmarkFile*, uri : Pointer(UInt8), is_private : LibC::Int) : Void
  fun g_bookmark_file_set_mime_type(this : BookmarkFile*, uri : Pointer(UInt8), mime_type : Pointer(UInt8)) : Void
  fun g_bookmark_file_set_modified(this : BookmarkFile*, uri : Pointer(UInt8), modified : Int64) : Void
  fun g_bookmark_file_set_modified_date_time(this : BookmarkFile*, uri : Pointer(UInt8), modified : Pointer(LibGLib::DateTime)) : Void
  fun g_bookmark_file_set_title(this : BookmarkFile*, uri : Pointer(UInt8), title : Pointer(UInt8)) : Void
  fun g_bookmark_file_set_visited(this : BookmarkFile*, uri : Pointer(UInt8), visited : Int64) : Void
  fun g_bookmark_file_set_visited_date_time(this : BookmarkFile*, uri : Pointer(UInt8), visited : Pointer(LibGLib::DateTime)) : Void
  fun g_bookmark_file_to_data(this : BookmarkFile*, length : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_bookmark_file_to_file(this : BookmarkFile*, filename : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_bookmark_file_error_quark : UInt32

  struct ByteArray # struct
    data : Pointer(UInt8)
    len : UInt32
  end
  fun g_byte_array_get_type : UInt64
  fun g_byte_array_free(array : Pointer(Void), free_segment : LibC::Int) : Pointer(UInt8)
  fun g_byte_array_free_to_bytes(array : Pointer(Void)) : Pointer(LibGLib::Bytes)
  fun g_byte_array_new : Pointer(Void)
  fun g_byte_array_new_take(data : Pointer(UInt8), len : UInt64) : Pointer(Void)
  fun g_byte_array_steal(array : Pointer(Void), len : UInt64*) : Pointer(UInt8)
  fun g_byte_array_unref(array : Pointer(Void)) : Void

  struct Bytes # struct
    _data : UInt8[0]
  end
  fun g_bytes_get_type : UInt64
  fun g_bytes_new(data : Pointer(UInt8), size : UInt64) : Pointer(LibGLib::Bytes)
  fun g_bytes_new_take(data : Pointer(UInt8), size : UInt64) : Pointer(LibGLib::Bytes)
  fun g_bytes_compare(this : Bytes*, bytes2 : Pointer(LibGLib::Bytes)) : Int32
  fun g_bytes_equal(this : Bytes*, bytes2 : Pointer(LibGLib::Bytes)) : LibC::Int
  fun g_bytes_get_data(this : Bytes*, size : UInt64*) : Pointer(UInt8)
  fun g_bytes_get_size(this : Bytes*) : UInt64
  fun g_bytes_hash(this : Bytes*) : UInt32
  fun g_bytes_new_from_bytes(this : Bytes*, offset : UInt64, length : UInt64) : Pointer(LibGLib::Bytes)
  fun g_bytes_ref(this : Bytes*) : Pointer(LibGLib::Bytes)
  fun g_bytes_unref(this : Bytes*) : Void
  fun g_bytes_unref_to_array(this : Bytes*) : Pointer(Void)
  fun g_bytes_unref_to_data(this : Bytes*, size : UInt64*) : Pointer(UInt8)

  struct Checksum # struct
    _data : UInt8[0]
  end
  fun g_checksum_get_type : UInt64
  fun g_checksum_new(checksum_type : LibGLib::ChecksumType) : Pointer(LibGLib::Checksum)
  fun g_checksum_copy(this : Checksum*) : Pointer(LibGLib::Checksum)
  fun g_checksum_free(this : Checksum*) : Void
  fun g_checksum_get_string(this : Checksum*) : Pointer(UInt8)
  fun g_checksum_reset(this : Checksum*) : Void
  fun g_checksum_update(this : Checksum*, data : Pointer(UInt8), length : Int64) : Void
  fun g_checksum_type_get_length(checksum_type : LibGLib::ChecksumType) : Int64

  struct Cond # struct
    p : Pointer(Void)
    i : UInt32[2]
  end
  fun g_cond_broadcast(this : Cond*) : Void
  fun g_cond_clear(this : Cond*) : Void
  fun g_cond_init(this : Cond*) : Void
  fun g_cond_signal(this : Cond*) : Void
  fun g_cond_wait(this : Cond*, mutex : Pointer(LibGLib::Mutex)) : Void
  fun g_cond_wait_until(this : Cond*, mutex : Pointer(LibGLib::Mutex), end_time : Int64) : LibC::Int

  struct Data # struct
    _data : UInt8[0]
  end

  struct Date # struct
    julian_days : UInt32
    julian : UInt32
    dmy : UInt32
    day : UInt32
    month : UInt32
    year : UInt32
  end
  fun g_date_get_type : UInt64
  fun g_date_new : Pointer(LibGLib::Date)
  fun g_date_new_dmy(day : UInt8, month : LibGLib::DateMonth, year : UInt16) : Pointer(LibGLib::Date)
  fun g_date_new_julian(julian_day : UInt32) : Pointer(LibGLib::Date)
  fun g_date_add_days(this : Date*, n_days : UInt32) : Void
  fun g_date_add_months(this : Date*, n_months : UInt32) : Void
  fun g_date_add_years(this : Date*, n_years : UInt32) : Void
  fun g_date_clamp(this : Date*, min_date : Pointer(LibGLib::Date), max_date : Pointer(LibGLib::Date)) : Void
  fun g_date_clear(this : Date*, n_dates : UInt32) : Void
  fun g_date_compare(this : Date*, rhs : Pointer(LibGLib::Date)) : Int32
  fun g_date_copy(this : Date*) : Pointer(LibGLib::Date)
  fun g_date_days_between(this : Date*, date2 : Pointer(LibGLib::Date)) : Int32
  fun g_date_free(this : Date*) : Void
  fun g_date_get_day(this : Date*) : UInt8
  fun g_date_get_day_of_year(this : Date*) : UInt32
  fun g_date_get_iso8601_week_of_year(this : Date*) : UInt32
  fun g_date_get_julian(this : Date*) : UInt32
  fun g_date_get_monday_week_of_year(this : Date*) : UInt32
  fun g_date_get_month(this : Date*) : LibGLib::DateMonth
  fun g_date_get_sunday_week_of_year(this : Date*) : UInt32
  fun g_date_get_weekday(this : Date*) : LibGLib::DateWeekday
  fun g_date_get_year(this : Date*) : UInt16
  fun g_date_is_first_of_month(this : Date*) : LibC::Int
  fun g_date_is_last_of_month(this : Date*) : LibC::Int
  fun g_date_order(this : Date*, date2 : Pointer(LibGLib::Date)) : Void
  fun g_date_set_day(this : Date*, day : UInt8) : Void
  fun g_date_set_dmy(this : Date*, day : UInt8, month : LibGLib::DateMonth, y : UInt16) : Void
  fun g_date_set_julian(this : Date*, julian_date : UInt32) : Void
  fun g_date_set_month(this : Date*, month : LibGLib::DateMonth) : Void
  fun g_date_set_parse(this : Date*, str : Pointer(UInt8)) : Void
  fun g_date_set_time(this : Date*, time_ : Int32) : Void
  fun g_date_set_time_t(this : Date*, timet : Int64) : Void
  fun g_date_set_time_val(this : Date*, timeval : Pointer(LibGLib::TimeVal)) : Void
  fun g_date_set_year(this : Date*, year : UInt16) : Void
  fun g_date_subtract_days(this : Date*, n_days : UInt32) : Void
  fun g_date_subtract_months(this : Date*, n_months : UInt32) : Void
  fun g_date_subtract_years(this : Date*, n_years : UInt32) : Void
  fun g_date_to_struct_tm(this : Date*, tm : Pointer(Void)) : Void
  fun g_date_valid(this : Date*) : LibC::Int
  fun g_date_get_days_in_month(month : LibGLib::DateMonth, year : UInt16) : UInt8
  fun g_date_get_monday_weeks_in_year(year : UInt16) : UInt8
  fun g_date_get_sunday_weeks_in_year(year : UInt16) : UInt8
  fun g_date_is_leap_year(year : UInt16) : LibC::Int
  fun g_date_strftime(s : Pointer(UInt8), slen : UInt64, format : Pointer(UInt8), date : Pointer(LibGLib::Date)) : UInt64
  fun g_date_valid_day(day : UInt8) : LibC::Int
  fun g_date_valid_dmy(day : UInt8, month : LibGLib::DateMonth, year : UInt16) : LibC::Int
  fun g_date_valid_julian(julian_date : UInt32) : LibC::Int
  fun g_date_valid_month(month : LibGLib::DateMonth) : LibC::Int
  fun g_date_valid_weekday(weekday : LibGLib::DateWeekday) : LibC::Int
  fun g_date_valid_year(year : UInt16) : LibC::Int

  struct DateTime # struct
    _data : UInt8[0]
  end
  fun g_date_time_get_type : UInt64
  fun g_date_time_new(tz : Pointer(LibGLib::TimeZone), year : Int32, month : Int32, day : Int32, hour : Int32, minute : Int32, seconds : Float64) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_from_iso8601(text : Pointer(UInt8), default_tz : Pointer(LibGLib::TimeZone)) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_from_timeval_local(tv : Pointer(LibGLib::TimeVal)) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_from_timeval_utc(tv : Pointer(LibGLib::TimeVal)) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_from_unix_local(t : Int64) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_from_unix_utc(t : Int64) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_local(year : Int32, month : Int32, day : Int32, hour : Int32, minute : Int32, seconds : Float64) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_now(tz : Pointer(LibGLib::TimeZone)) : Pointer(LibGLib::DateTime)
  fun g_date_time_new_now_local : Pointer(LibGLib::DateTime)
  fun g_date_time_new_now_utc : Pointer(LibGLib::DateTime)
  fun g_date_time_new_utc(year : Int32, month : Int32, day : Int32, hour : Int32, minute : Int32, seconds : Float64) : Pointer(LibGLib::DateTime)
  fun g_date_time_add(this : DateTime*, timespan : Int64) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_days(this : DateTime*, days : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_full(this : DateTime*, years : Int32, months : Int32, days : Int32, hours : Int32, minutes : Int32, seconds : Float64) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_hours(this : DateTime*, hours : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_minutes(this : DateTime*, minutes : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_months(this : DateTime*, months : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_seconds(this : DateTime*, seconds : Float64) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_weeks(this : DateTime*, weeks : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_add_years(this : DateTime*, years : Int32) : Pointer(LibGLib::DateTime)
  fun g_date_time_compare(this : DateTime*, dt2 : Pointer(LibGLib::DateTime)) : Int32
  fun g_date_time_difference(this : DateTime*, _begin : Pointer(LibGLib::DateTime)) : Int64
  fun g_date_time_equal(this : DateTime*, dt2 : Pointer(LibGLib::DateTime)) : LibC::Int
  fun g_date_time_format(this : DateTime*, format : Pointer(UInt8)) : Pointer(UInt8)
  fun g_date_time_format_iso8601(this : DateTime*) : Pointer(UInt8)
  fun g_date_time_get_day_of_month(this : DateTime*) : Int32
  fun g_date_time_get_day_of_week(this : DateTime*) : Int32
  fun g_date_time_get_day_of_year(this : DateTime*) : Int32
  fun g_date_time_get_hour(this : DateTime*) : Int32
  fun g_date_time_get_microsecond(this : DateTime*) : Int32
  fun g_date_time_get_minute(this : DateTime*) : Int32
  fun g_date_time_get_month(this : DateTime*) : Int32
  fun g_date_time_get_second(this : DateTime*) : Int32
  fun g_date_time_get_seconds(this : DateTime*) : Float64
  fun g_date_time_get_timezone(this : DateTime*) : Pointer(LibGLib::TimeZone)
  fun g_date_time_get_timezone_abbreviation(this : DateTime*) : Pointer(UInt8)
  fun g_date_time_get_utc_offset(this : DateTime*) : Int64
  fun g_date_time_get_week_numbering_year(this : DateTime*) : Int32
  fun g_date_time_get_week_of_year(this : DateTime*) : Int32
  fun g_date_time_get_year(this : DateTime*) : Int32
  fun g_date_time_get_ymd(this : DateTime*, year : Int32*, month : Int32*, day : Int32*) : Void
  fun g_date_time_hash(this : DateTime*) : UInt32
  fun g_date_time_is_daylight_savings(this : DateTime*) : LibC::Int
  fun g_date_time_ref(this : DateTime*) : Pointer(LibGLib::DateTime)
  fun g_date_time_to_local(this : DateTime*) : Pointer(LibGLib::DateTime)
  fun g_date_time_to_timeval(this : DateTime*, tv : Pointer(LibGLib::TimeVal)) : LibC::Int
  fun g_date_time_to_timezone(this : DateTime*, tz : Pointer(LibGLib::TimeZone)) : Pointer(LibGLib::DateTime)
  fun g_date_time_to_unix(this : DateTime*) : Int64
  fun g_date_time_to_utc(this : DateTime*) : Pointer(LibGLib::DateTime)
  fun g_date_time_unref(this : DateTime*) : Void

  struct DebugKey # struct
    key : Pointer(UInt8)
    value : UInt32
  end

  struct Dir # struct
    _data : UInt8[0]
  end
  fun g_dir_close(this : Dir*) : Void
  fun g_dir_read_name(this : Dir*) : Pointer(UInt8)
  fun g_dir_rewind(this : Dir*) : Void
  fun g_dir_make_tmp(tmpl : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)

  struct Error # struct
    domain : UInt32
    code : Int32
    message : Pointer(UInt8)
  end
  fun g_error_get_type : UInt64
  fun g_error_new_literal(domain : UInt32, code : Int32, message : Pointer(UInt8)) : Pointer(LibGLib::Error*)
  fun g_error_copy(this : Error*) : Pointer(LibGLib::Error*)
  fun g_error_free(this : Error*) : Void
  fun g_error_matches(this : Error*, domain : UInt32, code : Int32) : LibC::Int

  struct HashTable # struct
    _data : UInt8[0]
  end
  fun g_hash_table_get_type : UInt64
  fun g_hash_table_add(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_contains(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_destroy(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_insert(hash_table : Pointer(Void*), key : Pointer(Void), value : Pointer(Void)) : LibC::Int
  fun g_hash_table_lookup(hash_table : Pointer(Void*), key : Pointer(Void)) : Pointer(Void)
  fun g_hash_table_lookup_extended(hash_table : Pointer(Void*), lookup_key : Pointer(Void), orig_key : Pointer(Void)*, value : Pointer(Void)*) : LibC::Int
  fun g_hash_table_remove(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_remove_all(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_replace(hash_table : Pointer(Void*), key : Pointer(Void), value : Pointer(Void)) : LibC::Int
  fun g_hash_table_size(hash_table : Pointer(Void*)) : UInt32
  fun g_hash_table_steal(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_steal_all(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_steal_extended(hash_table : Pointer(Void*), lookup_key : Pointer(Void), stolen_key : Pointer(Void)*, stolen_value : Pointer(Void)*) : LibC::Int
  fun g_hash_table_unref(hash_table : Pointer(Void*)) : Void

  struct HashTableIter # struct
    dummy1 : Pointer(Void)
    dummy2 : Pointer(Void)
    dummy3 : Pointer(Void)
    dummy4 : Int32
    dummy5 : LibC::Int
    dummy6 : Pointer(Void)
  end
  fun g_hash_table_iter_init(this : HashTableIter*, hash_table : Pointer(Void*)) : Void
  fun g_hash_table_iter_next(this : HashTableIter*, key : Pointer(Void)*, value : Pointer(Void)*) : LibC::Int
  fun g_hash_table_iter_remove(this : HashTableIter*) : Void
  fun g_hash_table_iter_replace(this : HashTableIter*, value : Pointer(Void)) : Void
  fun g_hash_table_iter_steal(this : HashTableIter*) : Void

  struct Hmac # struct
    _data : UInt8[0]
  end
  fun g_hmac_get_digest(this : Hmac*, buffer : Pointer(UInt8), digest_len : UInt64*) : Void
  fun g_hmac_get_string(this : Hmac*) : Pointer(UInt8)
  fun g_hmac_unref(this : Hmac*) : Void
  fun g_hmac_update(this : Hmac*, data : Pointer(UInt8), length : Int64) : Void

  struct Hook # struct
    data : Pointer(Void)
    _next : Pointer(LibGLib::Hook)
    prev : Pointer(LibGLib::Hook)
    ref_count : UInt32
    hook_id : UInt64
    flags : UInt32
    func : Pointer(Void)
    destroy : LibGLib::DestroyNotify
  end
  fun g_hook_compare_ids(this : Hook*, sibling : Pointer(LibGLib::Hook)) : Int32
  fun g_hook_destroy(hook_list : Pointer(LibGLib::HookList), hook_id : UInt64) : LibC::Int
  fun g_hook_destroy_link(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_free(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_insert_before(hook_list : Pointer(LibGLib::HookList), sibling : Pointer(LibGLib::Hook), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_prepend(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_unref(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void

  struct HookList # struct
    seq_id : UInt64
    hook_size : UInt32
    is_setup : UInt32
    hooks : Pointer(LibGLib::Hook)
    dummy3 : Pointer(Void)
    finalize_hook : LibGLib::HookFinalizeFunc
    dummy : Pointer(Void)[2]
  end
  fun g_hook_list_clear(this : HookList*) : Void
  fun g_hook_list_init(this : HookList*, hook_size : UInt32) : Void
  fun g_hook_list_invoke(this : HookList*, may_recurse : LibC::Int) : Void
  fun g_hook_list_invoke_check(this : HookList*, may_recurse : LibC::Int) : Void

  struct IOChannel # struct
    ref_count : Int32
    funcs : Pointer(LibGLib::IOFuncs)
    encoding : Pointer(UInt8)
    read_cd : Pointer(Void)
    write_cd : Pointer(Void)
    line_term : Pointer(UInt8)
    line_term_len : UInt32
    buf_size : UInt64
    read_buf : Pointer(LibGLib::String)
    encoded_read_buf : Pointer(LibGLib::String)
    write_buf : Pointer(LibGLib::String)
    partial_write_buf : Int8[6]
    use_buffer : UInt32
    do_encode : UInt32
    close_on_unref : UInt32
    is_readable : UInt32
    is_writeable : UInt32
    is_seekable : UInt32
    reserved1 : Pointer(Void)
    reserved2 : Pointer(Void)
  end
  fun g_io_channel_get_type : UInt64
  fun g_io_channel_new_file(filename : Pointer(UInt8), mode : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::IOChannel)
  fun g_io_channel_unix_new(fd : Int32) : Pointer(LibGLib::IOChannel)
  fun g_io_channel_close(this : IOChannel*) : Void
  fun g_io_channel_flush(this : IOChannel*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_get_buffer_condition(this : IOChannel*) : LibGLib::IOCondition
  fun g_io_channel_get_buffer_size(this : IOChannel*) : UInt64
  fun g_io_channel_get_buffered(this : IOChannel*) : LibC::Int
  fun g_io_channel_get_close_on_unref(this : IOChannel*) : LibC::Int
  fun g_io_channel_get_encoding(this : IOChannel*) : Pointer(UInt8)
  fun g_io_channel_get_flags(this : IOChannel*) : LibGLib::IOFlags
  fun g_io_channel_get_line_term(this : IOChannel*, length : Pointer(Int32)) : Pointer(UInt8)
  fun g_io_channel_init(this : IOChannel*) : Void
  fun g_io_channel_read(this : IOChannel*, buf : Pointer(UInt8), count : UInt64, bytes_read : Pointer(UInt64)) : LibGLib::IOError
  fun g_io_channel_read_chars(this : IOChannel*, buf : Pointer(UInt8)*, count : UInt64, bytes_read : UInt64*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_read_line(this : IOChannel*, str_return : Pointer(UInt8)*, length : UInt64*, terminator_pos : UInt64*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_read_line_string(this : IOChannel*, buffer : Pointer(LibGLib::String), terminator_pos : Pointer(UInt64), error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_read_to_end(this : IOChannel*, str_return : Pointer(UInt8)*, length : UInt64*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_read_unichar(this : IOChannel*, thechar : UInt8*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_ref(this : IOChannel*) : Pointer(LibGLib::IOChannel)
  fun g_io_channel_seek(this : IOChannel*, offset : Int64, type : LibGLib::SeekType) : LibGLib::IOError
  fun g_io_channel_seek_position(this : IOChannel*, offset : Int64, type : LibGLib::SeekType, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_set_buffer_size(this : IOChannel*, size : UInt64) : Void
  fun g_io_channel_set_buffered(this : IOChannel*, buffered : LibC::Int) : Void
  fun g_io_channel_set_close_on_unref(this : IOChannel*, do_close : LibC::Int) : Void
  fun g_io_channel_set_encoding(this : IOChannel*, encoding : Pointer(UInt8), error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_set_flags(this : IOChannel*, flags : LibGLib::IOFlags, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_set_line_term(this : IOChannel*, line_term : Pointer(UInt8), length : Int32) : Void
  fun g_io_channel_shutdown(this : IOChannel*, flush : LibC::Int, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_unix_get_fd(this : IOChannel*) : Int32
  fun g_io_channel_unref(this : IOChannel*) : Void
  fun g_io_channel_write(this : IOChannel*, buf : Pointer(UInt8), count : UInt64, bytes_written : Pointer(UInt64)) : LibGLib::IOError
  fun g_io_channel_write_chars(this : IOChannel*, buf : Pointer(UInt8), count : Int64, bytes_written : UInt64*, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_write_unichar(this : IOChannel*, thechar : UInt8, error : LibGLib::Error**) : LibGLib::IOStatus
  fun g_io_channel_error_from_errno(en : Int32) : LibGLib::IOChannelError
  fun g_io_channel_error_quark : UInt32

  struct IOFuncs # struct
    io_read : Pointer(LibGLib::IOChannel), Pointer(UInt8), UInt64, Pointer(UInt64), LibGLib::Error* -> LibGLib::IOStatus
    io_write : Pointer(LibGLib::IOChannel), Pointer(UInt8), UInt64, Pointer(UInt64), LibGLib::Error* -> LibGLib::IOStatus
    io_seek : Pointer(LibGLib::IOChannel), Int64, LibGLib::SeekType, LibGLib::Error* -> LibGLib::IOStatus
    io_close : Pointer(LibGLib::IOChannel), LibGLib::Error* -> LibGLib::IOStatus
    io_create_watch : Pointer(LibGLib::IOChannel), LibGLib::IOCondition -> Pointer(LibGLib::Source)
    io_free : Pointer(LibGLib::IOChannel) -> Void
    io_set_flags : Pointer(LibGLib::IOChannel), LibGLib::IOFlags, LibGLib::Error* -> LibGLib::IOStatus
    io_get_flags : Pointer(LibGLib::IOChannel) -> LibGLib::IOFlags
  end

  struct KeyFile # struct
    _data : UInt8[0]
  end
  fun g_key_file_get_type : UInt64
  fun g_key_file_new : Pointer(LibGLib::KeyFile)
  fun g_key_file_get_boolean(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_get_boolean_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(LibC::Int)
  fun g_key_file_get_comment(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_key_file_get_double(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Float64
  fun g_key_file_get_double_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Float64)
  fun g_key_file_get_groups(this : KeyFile*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_key_file_get_int64(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Int64
  fun g_key_file_get_integer(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Int32
  fun g_key_file_get_integer_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Int32)
  fun g_key_file_get_keys(this : KeyFile*, group_name : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_key_file_get_locale_for_key(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), locale : Pointer(UInt8)) : Pointer(UInt8)
  fun g_key_file_get_locale_string(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), locale : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_key_file_get_locale_string_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), locale : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_key_file_get_start_group(this : KeyFile*) : Pointer(UInt8)
  fun g_key_file_get_string(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_key_file_get_string_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), length : UInt64*, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_key_file_get_uint64(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : UInt64
  fun g_key_file_get_value(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_key_file_has_group(this : KeyFile*, group_name : Pointer(UInt8)) : LibC::Int
  fun g_key_file_load_from_bytes(this : KeyFile*, bytes : Pointer(LibGLib::Bytes), flags : LibGLib::KeyFileFlags, error : LibGLib::Error**) : LibC::Int
  fun g_key_file_load_from_data(this : KeyFile*, data : Pointer(UInt8), length : UInt64, flags : LibGLib::KeyFileFlags, error : LibGLib::Error**) : LibC::Int
  fun g_key_file_load_from_data_dirs(this : KeyFile*, file : Pointer(UInt8), full_path : Pointer(UInt8)*, flags : LibGLib::KeyFileFlags, error : LibGLib::Error**) : LibC::Int
  fun g_key_file_load_from_dirs(this : KeyFile*, file : Pointer(UInt8), search_dirs : Pointer(Pointer(UInt8)), full_path : Pointer(UInt8)*, flags : LibGLib::KeyFileFlags, error : LibGLib::Error**) : LibC::Int
  fun g_key_file_load_from_file(this : KeyFile*, file : Pointer(UInt8), flags : LibGLib::KeyFileFlags, error : LibGLib::Error**) : LibC::Int
  fun g_key_file_remove_comment(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_remove_group(this : KeyFile*, group_name : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_remove_key(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_save_to_file(this : KeyFile*, filename : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_set_boolean(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : LibC::Int) : Void
  fun g_key_file_set_boolean_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), list : Pointer(LibC::Int), length : UInt64) : Void
  fun g_key_file_set_comment(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), comment : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_key_file_set_double(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : Float64) : Void
  fun g_key_file_set_double_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), list : Pointer(Float64), length : UInt64) : Void
  fun g_key_file_set_int64(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : Int64) : Void
  fun g_key_file_set_integer(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : Int32) : Void
  fun g_key_file_set_integer_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), list : Pointer(Int32), length : UInt64) : Void
  fun g_key_file_set_list_separator(this : KeyFile*, separator : Int8) : Void
  fun g_key_file_set_locale_string(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), locale : Pointer(UInt8), string : Pointer(UInt8)) : Void
  fun g_key_file_set_locale_string_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), locale : Pointer(UInt8), list : Pointer(Pointer(UInt8)), length : UInt64) : Void
  fun g_key_file_set_string(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), string : Pointer(UInt8)) : Void
  fun g_key_file_set_string_list(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), list : Pointer(Pointer(UInt8)), length : UInt64) : Void
  fun g_key_file_set_uint64(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : UInt64) : Void
  fun g_key_file_set_value(this : KeyFile*, group_name : Pointer(UInt8), key : Pointer(UInt8), value : Pointer(UInt8)) : Void
  fun g_key_file_to_data(this : KeyFile*, length : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_key_file_unref(this : KeyFile*) : Void
  fun g_key_file_error_quark : UInt32

  struct List # struct
    data : Pointer(Void)
    _next : Pointer(Void*)
    prev : Pointer(Void*)
  end

  struct LogField # struct
    key : Pointer(UInt8)
    value : Pointer(Void)
    length : Int64
  end

  struct MainContext # struct
    _data : UInt8[0]
  end
  fun g_main_context_get_type : UInt64
  fun g_main_context_new : Pointer(LibGLib::MainContext)
  fun g_main_context_acquire(this : MainContext*) : LibC::Int
  fun g_main_context_add_poll(this : MainContext*, fd : Pointer(LibGLib::PollFD), priority : Int32) : Void
  fun g_main_context_check(this : MainContext*, max_priority : Int32, fds : Pointer(LibGLib::PollFD), n_fds : Int32) : LibC::Int
  fun g_main_context_dispatch(this : MainContext*) : Void
  fun g_main_context_find_source_by_funcs_user_data(this : MainContext*, funcs : Pointer(LibGLib::SourceFuncs), user_data : Pointer(Void)) : Pointer(LibGLib::Source)
  fun g_main_context_find_source_by_id(this : MainContext*, source_id : UInt32) : Pointer(LibGLib::Source)
  fun g_main_context_find_source_by_user_data(this : MainContext*, user_data : Pointer(Void)) : Pointer(LibGLib::Source)
  fun g_main_context_invoke_full(this : MainContext*, priority : Int32, function : LibGLib::SourceFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : Void
  fun g_main_context_is_owner(this : MainContext*) : LibC::Int
  fun g_main_context_iteration(this : MainContext*, may_block : LibC::Int) : LibC::Int
  fun g_main_context_pending(this : MainContext*) : LibC::Int
  fun g_main_context_pop_thread_default(this : MainContext*) : Void
  fun g_main_context_prepare(this : MainContext*, priority : Int32*) : LibC::Int
  fun g_main_context_push_thread_default(this : MainContext*) : Void
  fun g_main_context_query(this : MainContext*, max_priority : Int32, timeout_ : Int32*, fds : Pointer(LibGLib::PollFD)*, n_fds : Int32) : Int32
  fun g_main_context_ref(this : MainContext*) : Pointer(LibGLib::MainContext)
  fun g_main_context_release(this : MainContext*) : Void
  fun g_main_context_remove_poll(this : MainContext*, fd : Pointer(LibGLib::PollFD)) : Void
  fun g_main_context_unref(this : MainContext*) : Void
  fun g_main_context_wait(this : MainContext*, cond : Pointer(LibGLib::Cond), mutex : Pointer(LibGLib::Mutex)) : LibC::Int
  fun g_main_context_wakeup(this : MainContext*) : Void
  fun g_main_context_default : Pointer(LibGLib::MainContext)
  fun g_main_context_get_thread_default : Pointer(LibGLib::MainContext)
  fun g_main_context_ref_thread_default : Pointer(LibGLib::MainContext)

  struct MainLoop # struct
    _data : UInt8[0]
  end
  fun g_main_loop_get_type : UInt64
  fun g_main_loop_new(context : Pointer(LibGLib::MainContext), is_running : LibC::Int) : Pointer(LibGLib::MainLoop)
  fun g_main_loop_get_context(this : MainLoop*) : Pointer(LibGLib::MainContext)
  fun g_main_loop_is_running(this : MainLoop*) : LibC::Int
  fun g_main_loop_quit(this : MainLoop*) : Void
  fun g_main_loop_ref(this : MainLoop*) : Pointer(LibGLib::MainLoop)
  fun g_main_loop_run(this : MainLoop*) : Void
  fun g_main_loop_unref(this : MainLoop*) : Void

  struct MappedFile # struct
    _data : UInt8[0]
  end
  fun g_mapped_file_get_type : UInt64
  fun g_mapped_file_new(filename : Pointer(UInt8), writable : LibC::Int, error : LibGLib::Error**) : Pointer(LibGLib::MappedFile)
  fun g_mapped_file_new_from_fd(fd : Int32, writable : LibC::Int, error : LibGLib::Error**) : Pointer(LibGLib::MappedFile)
  fun g_mapped_file_free(this : MappedFile*) : Void
  fun g_mapped_file_get_bytes(this : MappedFile*) : Pointer(LibGLib::Bytes)
  fun g_mapped_file_get_contents(this : MappedFile*) : Pointer(UInt8)
  fun g_mapped_file_get_length(this : MappedFile*) : UInt64
  fun g_mapped_file_ref(this : MappedFile*) : Pointer(LibGLib::MappedFile)
  fun g_mapped_file_unref(this : MappedFile*) : Void

  struct MarkupParseContext # struct
    _data : UInt8[0]
  end
  fun g_markup_parse_context_get_type : UInt64
  fun g_markup_parse_context_new(parser : Pointer(LibGLib::MarkupParser), flags : LibGLib::MarkupParseFlags, user_data : Pointer(Void), user_data_dnotify : LibGLib::DestroyNotify) : Pointer(LibGLib::MarkupParseContext)
  fun g_markup_parse_context_end_parse(this : MarkupParseContext*, error : LibGLib::Error**) : LibC::Int
  fun g_markup_parse_context_free(this : MarkupParseContext*) : Void
  fun g_markup_parse_context_get_element(this : MarkupParseContext*) : Pointer(UInt8)
  fun g_markup_parse_context_get_position(this : MarkupParseContext*, line_number : Int32*, char_number : Int32*) : Void
  fun g_markup_parse_context_get_user_data(this : MarkupParseContext*) : Pointer(Void)
  fun g_markup_parse_context_parse(this : MarkupParseContext*, text : Pointer(UInt8), text_len : Int64, error : LibGLib::Error**) : LibC::Int
  fun g_markup_parse_context_pop(this : MarkupParseContext*) : Pointer(Void)
  fun g_markup_parse_context_push(this : MarkupParseContext*, parser : Pointer(LibGLib::MarkupParser), user_data : Pointer(Void)) : Void
  fun g_markup_parse_context_ref(this : MarkupParseContext*) : Pointer(LibGLib::MarkupParseContext)
  fun g_markup_parse_context_unref(this : MarkupParseContext*) : Void

  struct MarkupParser # struct
    start_element : Pointer(LibGLib::MarkupParseContext), Pointer(UInt8), Pointer(UInt8), Pointer(UInt8), Pointer(Void), LibGLib::Error* -> Void
    end_element : Pointer(LibGLib::MarkupParseContext), Pointer(UInt8), Pointer(Void), LibGLib::Error* -> Void
    text : Pointer(LibGLib::MarkupParseContext), Pointer(UInt8), UInt64, Pointer(Void), LibGLib::Error* -> Void
    passthrough : Pointer(LibGLib::MarkupParseContext), Pointer(UInt8), UInt64, Pointer(Void), LibGLib::Error* -> Void
    error : Pointer(LibGLib::MarkupParseContext), Pointer(LibGLib::Error*), Pointer(Void) -> Void
  end

  struct MatchInfo # struct
    _data : UInt8[0]
  end
  fun g_match_info_get_type : UInt64
  fun g_match_info_expand_references(this : MatchInfo*, string_to_expand : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_match_info_fetch(this : MatchInfo*, match_num : Int32) : Pointer(UInt8)
  fun g_match_info_fetch_all(this : MatchInfo*) : Pointer(Pointer(UInt8))
  fun g_match_info_fetch_named(this : MatchInfo*, name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_match_info_fetch_named_pos(this : MatchInfo*, name : Pointer(UInt8), start_pos : Int32*, end_pos : Int32*) : LibC::Int
  fun g_match_info_fetch_pos(this : MatchInfo*, match_num : Int32, start_pos : Int32*, end_pos : Int32*) : LibC::Int
  fun g_match_info_free(this : MatchInfo*) : Void
  fun g_match_info_get_match_count(this : MatchInfo*) : Int32
  fun g_match_info_get_regex(this : MatchInfo*) : Pointer(LibGLib::Regex)
  fun g_match_info_get_string(this : MatchInfo*) : Pointer(UInt8)
  fun g_match_info_is_partial_match(this : MatchInfo*) : LibC::Int
  fun g_match_info_matches(this : MatchInfo*) : LibC::Int
  fun g_match_info_next(this : MatchInfo*, error : LibGLib::Error**) : LibC::Int
  fun g_match_info_ref(this : MatchInfo*) : Pointer(LibGLib::MatchInfo)
  fun g_match_info_unref(this : MatchInfo*) : Void

  struct MemVTable # struct
    malloc : UInt64 -> Pointer(Void)
    realloc : Pointer(Void), UInt64 -> Pointer(Void)
    free : Pointer(Void) -> Void
    calloc : UInt64, UInt64 -> Pointer(Void)
    try_malloc : UInt64 -> Pointer(Void)
    try_realloc : Pointer(Void), UInt64 -> Pointer(Void)
  end

  struct Node # struct
    data : Pointer(Void)
    _next : Pointer(LibGLib::Node)
    prev : Pointer(LibGLib::Node)
    parent : Pointer(LibGLib::Node)
    children : Pointer(LibGLib::Node)
  end
  fun g_node_child_index(this : Node*, data : Pointer(Void)) : Int32
  fun g_node_child_position(this : Node*, child : Pointer(LibGLib::Node)) : Int32
  fun g_node_depth(this : Node*) : UInt32
  fun g_node_destroy(this : Node*) : Void
  fun g_node_is_ancestor(this : Node*, descendant : Pointer(LibGLib::Node)) : LibC::Int
  fun g_node_max_height(this : Node*) : UInt32
  fun g_node_n_children(this : Node*) : UInt32
  fun g_node_n_nodes(this : Node*, flags : LibGLib::TraverseFlags) : UInt32
  fun g_node_reverse_children(this : Node*) : Void
  fun g_node_unlink(this : Node*) : Void

  struct Once # struct
    status : LibGLib::OnceStatus
    retval : Pointer(Void)
  end
  fun g_once_init_enter(location : Pointer(Void)) : LibC::Int
  fun g_once_init_leave(location : Pointer(Void), result : UInt64) : Void

  struct OptionContext # struct
    _data : UInt8[0]
  end
  fun g_option_context_add_group(this : OptionContext*, group : Pointer(LibGLib::OptionGroup)) : Void
  fun g_option_context_add_main_entries(this : OptionContext*, entries : Pointer(LibGLib::OptionEntry), translation_domain : Pointer(UInt8)) : Void
  fun g_option_context_free(this : OptionContext*) : Void
  fun g_option_context_get_description(this : OptionContext*) : Pointer(UInt8)
  fun g_option_context_get_help(this : OptionContext*, main_help : LibC::Int, group : Pointer(LibGLib::OptionGroup)) : Pointer(UInt8)
  fun g_option_context_get_help_enabled(this : OptionContext*) : LibC::Int
  fun g_option_context_get_ignore_unknown_options(this : OptionContext*) : LibC::Int
  fun g_option_context_get_main_group(this : OptionContext*) : Pointer(LibGLib::OptionGroup)
  fun g_option_context_get_strict_posix(this : OptionContext*) : LibC::Int
  fun g_option_context_get_summary(this : OptionContext*) : Pointer(UInt8)
  fun g_option_context_parse(this : OptionContext*, argc : Int32*, argv : Pointer(Pointer(UInt8))*, error : LibGLib::Error**) : LibC::Int
  fun g_option_context_parse_strv(this : OptionContext*, arguments : Pointer(Pointer(UInt8))*, error : LibGLib::Error**) : LibC::Int
  fun g_option_context_set_description(this : OptionContext*, description : Pointer(UInt8)) : Void
  fun g_option_context_set_help_enabled(this : OptionContext*, help_enabled : LibC::Int) : Void
  fun g_option_context_set_ignore_unknown_options(this : OptionContext*, ignore_unknown : LibC::Int) : Void
  fun g_option_context_set_main_group(this : OptionContext*, group : Pointer(LibGLib::OptionGroup)) : Void
  fun g_option_context_set_strict_posix(this : OptionContext*, strict_posix : LibC::Int) : Void
  fun g_option_context_set_summary(this : OptionContext*, summary : Pointer(UInt8)) : Void
  fun g_option_context_set_translate_func(this : OptionContext*, func : LibGLib::TranslateFunc, data : Pointer(Void), destroy_notify : LibGLib::DestroyNotify) : Void
  fun g_option_context_set_translation_domain(this : OptionContext*, domain : Pointer(UInt8)) : Void

  struct OptionEntry # struct
    long_name : Pointer(UInt8)
    short_name : Int8
    flags : Int32
    arg : LibGLib::OptionArg
    arg_data : Pointer(Void)
    description : Pointer(UInt8)
    arg_description : Pointer(UInt8)
  end

  struct OptionGroup # struct
    _data : UInt8[0]
  end
  fun g_option_group_get_type : UInt64
  fun g_option_group_new(name : Pointer(UInt8), description : Pointer(UInt8), help_description : Pointer(UInt8), user_data : Pointer(Void), destroy : LibGLib::DestroyNotify) : Pointer(LibGLib::OptionGroup)
  fun g_option_group_add_entries(this : OptionGroup*, entries : Pointer(LibGLib::OptionEntry)) : Void
  fun g_option_group_free(this : OptionGroup*) : Void
  fun g_option_group_ref(this : OptionGroup*) : Pointer(LibGLib::OptionGroup)
  fun g_option_group_set_translate_func(this : OptionGroup*, func : LibGLib::TranslateFunc, data : Pointer(Void), destroy_notify : LibGLib::DestroyNotify) : Void
  fun g_option_group_set_translation_domain(this : OptionGroup*, domain : Pointer(UInt8)) : Void
  fun g_option_group_unref(this : OptionGroup*) : Void

  struct PatternSpec # struct
    _data : UInt8[0]
  end
  fun g_pattern_spec_equal(this : PatternSpec*, pspec2 : Pointer(LibGLib::PatternSpec)) : LibC::Int
  fun g_pattern_spec_free(this : PatternSpec*) : Void

  struct PollFD # struct
    fd : Int32
    events : UInt16
    revents : UInt16
  end
  fun g_pollfd_get_type : UInt64

  struct Private # struct
    p : Pointer(Void)
    notify : LibGLib::DestroyNotify
    future : Pointer(Void)[2]
  end
  fun g_private_get(this : Private*) : Pointer(Void)
  fun g_private_replace(this : Private*, value : Pointer(Void)) : Void
  fun g_private_set(this : Private*, value : Pointer(Void)) : Void

  struct PtrArray # struct
    pdata : Pointer(Void)
    len : UInt32
  end
  fun g_ptr_array_get_type : UInt64

  struct Queue # struct
    head : Pointer(Void*)
    tail : Pointer(Void*)
    length : UInt32
  end
  fun g_queue_clear(this : Queue*) : Void
  fun g_queue_clear_full(this : Queue*, free_func : LibGLib::DestroyNotify) : Void
  fun g_queue_free(this : Queue*) : Void
  fun g_queue_free_full(this : Queue*, free_func : LibGLib::DestroyNotify) : Void
  fun g_queue_get_length(this : Queue*) : UInt32
  fun g_queue_index(this : Queue*, data : Pointer(Void)) : Int32
  fun g_queue_init(this : Queue*) : Void
  fun g_queue_is_empty(this : Queue*) : LibC::Int
  fun g_queue_peek_head(this : Queue*) : Pointer(Void)
  fun g_queue_peek_nth(this : Queue*, n : UInt32) : Pointer(Void)
  fun g_queue_peek_tail(this : Queue*) : Pointer(Void)
  fun g_queue_pop_head(this : Queue*) : Pointer(Void)
  fun g_queue_pop_nth(this : Queue*, n : UInt32) : Pointer(Void)
  fun g_queue_pop_tail(this : Queue*) : Pointer(Void)
  fun g_queue_push_head(this : Queue*, data : Pointer(Void)) : Void
  fun g_queue_push_nth(this : Queue*, data : Pointer(Void), n : Int32) : Void
  fun g_queue_push_tail(this : Queue*, data : Pointer(Void)) : Void
  fun g_queue_remove(this : Queue*, data : Pointer(Void)) : LibC::Int
  fun g_queue_remove_all(this : Queue*, data : Pointer(Void)) : UInt32
  fun g_queue_reverse(this : Queue*) : Void

  struct RWLock # struct
    p : Pointer(Void)
    i : UInt32[2]
  end
  fun g_rw_lock_clear(this : RWLock*) : Void
  fun g_rw_lock_init(this : RWLock*) : Void
  fun g_rw_lock_reader_lock(this : RWLock*) : Void
  fun g_rw_lock_reader_trylock(this : RWLock*) : LibC::Int
  fun g_rw_lock_reader_unlock(this : RWLock*) : Void
  fun g_rw_lock_writer_lock(this : RWLock*) : Void
  fun g_rw_lock_writer_trylock(this : RWLock*) : LibC::Int
  fun g_rw_lock_writer_unlock(this : RWLock*) : Void

  struct Rand # struct
    _data : UInt8[0]
  end
  fun g_rand_double(this : Rand*) : Float64
  fun g_rand_double_range(this : Rand*, _begin : Float64, _end : Float64) : Float64
  fun g_rand_free(this : Rand*) : Void
  fun g_rand_int(this : Rand*) : UInt32
  fun g_rand_int_range(this : Rand*, _begin : Int32, _end : Int32) : Int32
  fun g_rand_set_seed(this : Rand*, seed : UInt32) : Void
  fun g_rand_set_seed_array(this : Rand*, seed : Pointer(UInt32), seed_length : UInt32) : Void

  struct RecMutex # struct
    p : Pointer(Void)
    i : UInt32[2]
  end
  fun g_rec_mutex_clear(this : RecMutex*) : Void
  fun g_rec_mutex_init(this : RecMutex*) : Void
  fun g_rec_mutex_lock(this : RecMutex*) : Void
  fun g_rec_mutex_trylock(this : RecMutex*) : LibC::Int
  fun g_rec_mutex_unlock(this : RecMutex*) : Void

  struct Regex # struct
    _data : UInt8[0]
  end
  fun g_regex_get_type : UInt64
  fun g_regex_new(pattern : Pointer(UInt8), compile_options : LibGLib::RegexCompileFlags, match_options : LibGLib::RegexMatchFlags, error : LibGLib::Error**) : Pointer(LibGLib::Regex)
  fun g_regex_get_capture_count(this : Regex*) : Int32
  fun g_regex_get_compile_flags(this : Regex*) : LibGLib::RegexCompileFlags
  fun g_regex_get_has_cr_or_lf(this : Regex*) : LibC::Int
  fun g_regex_get_match_flags(this : Regex*) : LibGLib::RegexMatchFlags
  fun g_regex_get_max_backref(this : Regex*) : Int32
  fun g_regex_get_max_lookbehind(this : Regex*) : Int32
  fun g_regex_get_pattern(this : Regex*) : Pointer(UInt8)
  fun g_regex_get_string_number(this : Regex*, name : Pointer(UInt8)) : Int32
  fun g_regex_match(this : Regex*, string : Pointer(UInt8), match_options : LibGLib::RegexMatchFlags, match_info : Pointer(LibGLib::MatchInfo)*) : LibC::Int
  fun g_regex_match_all(this : Regex*, string : Pointer(UInt8), match_options : LibGLib::RegexMatchFlags, match_info : Pointer(LibGLib::MatchInfo)*) : LibC::Int
  fun g_regex_match_all_full(this : Regex*, string : Pointer(Pointer(UInt8)), string_len : Int64, start_position : Int32, match_options : LibGLib::RegexMatchFlags, match_info : Pointer(LibGLib::MatchInfo)*, error : LibGLib::Error**) : LibC::Int
  fun g_regex_match_full(this : Regex*, string : Pointer(Pointer(UInt8)), string_len : Int64, start_position : Int32, match_options : LibGLib::RegexMatchFlags, match_info : Pointer(LibGLib::MatchInfo)*, error : LibGLib::Error**) : LibC::Int
  fun g_regex_ref(this : Regex*) : Pointer(LibGLib::Regex)
  fun g_regex_replace(this : Regex*, string : Pointer(Pointer(UInt8)), string_len : Int64, start_position : Int32, replacement : Pointer(UInt8), match_options : LibGLib::RegexMatchFlags, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_regex_replace_literal(this : Regex*, string : Pointer(Pointer(UInt8)), string_len : Int64, start_position : Int32, replacement : Pointer(UInt8), match_options : LibGLib::RegexMatchFlags, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_regex_split(this : Regex*, string : Pointer(UInt8), match_options : LibGLib::RegexMatchFlags) : Pointer(Pointer(UInt8))
  fun g_regex_split_full(this : Regex*, string : Pointer(Pointer(UInt8)), string_len : Int64, start_position : Int32, match_options : LibGLib::RegexMatchFlags, max_tokens : Int32, error : LibGLib::Error**) : Pointer(Pointer(UInt8))
  fun g_regex_unref(this : Regex*) : Void
  fun g_regex_check_replacement(replacement : Pointer(UInt8), has_references : LibC::Int*, error : LibGLib::Error**) : LibC::Int
  fun g_regex_error_quark : UInt32
  fun g_regex_escape_nul(string : Pointer(UInt8), length : Int32) : Pointer(UInt8)
  fun g_regex_escape_string(string : Pointer(Pointer(UInt8)), length : Int32) : Pointer(UInt8)
  fun g_regex_match_simple(pattern : Pointer(UInt8), string : Pointer(UInt8), compile_options : LibGLib::RegexCompileFlags, match_options : LibGLib::RegexMatchFlags) : LibC::Int
  fun g_regex_split_simple(pattern : Pointer(UInt8), string : Pointer(UInt8), compile_options : LibGLib::RegexCompileFlags, match_options : LibGLib::RegexMatchFlags) : Pointer(Pointer(UInt8))

  struct SList # struct
    data : Pointer(Void)
    _next : Pointer(Void*)
  end

  struct Scanner # struct
    user_data : Pointer(Void)
    max_parse_errors : UInt32
    parse_errors : UInt32
    input_name : Pointer(UInt8)
    qdata : Pointer(LibGLib::Data)
    config : Pointer(LibGLib::ScannerConfig)
    token : LibGLib::TokenType
    value : LibGLib::TokenValue
    line : UInt32
    position : UInt32
    next_token : LibGLib::TokenType
    next_value : LibGLib::TokenValue
    next_line : UInt32
    next_position : UInt32
    symbol_table : Pointer(Void*)
    input_fd : Int32
    text : Pointer(UInt8)
    text_end : Pointer(UInt8)
    buffer : Pointer(UInt8)
    scope_id : UInt32
    msg_handler : LibGLib::ScannerMsgFunc
  end
  fun g_scanner_cur_line(this : Scanner*) : UInt32
  fun g_scanner_cur_position(this : Scanner*) : UInt32
  fun g_scanner_cur_token(this : Scanner*) : LibGLib::TokenType
  fun g_scanner_destroy(this : Scanner*) : Void
  fun g_scanner_eof(this : Scanner*) : LibC::Int
  fun g_scanner_get_next_token(this : Scanner*) : LibGLib::TokenType
  fun g_scanner_input_file(this : Scanner*, input_fd : Int32) : Void
  fun g_scanner_input_text(this : Scanner*, text : Pointer(UInt8), text_len : UInt32) : Void
  fun g_scanner_lookup_symbol(this : Scanner*, symbol : Pointer(UInt8)) : Pointer(Void)
  fun g_scanner_peek_next_token(this : Scanner*) : LibGLib::TokenType
  fun g_scanner_scope_add_symbol(this : Scanner*, scope_id : UInt32, symbol : Pointer(UInt8), value : Pointer(Void)) : Void
  fun g_scanner_scope_lookup_symbol(this : Scanner*, scope_id : UInt32, symbol : Pointer(UInt8)) : Pointer(Void)
  fun g_scanner_scope_remove_symbol(this : Scanner*, scope_id : UInt32, symbol : Pointer(UInt8)) : Void
  fun g_scanner_set_scope(this : Scanner*, scope_id : UInt32) : UInt32
  fun g_scanner_sync_file_offset(this : Scanner*) : Void
  fun g_scanner_unexp_token(this : Scanner*, expected_token : LibGLib::TokenType, identifier_spec : Pointer(UInt8), symbol_spec : Pointer(UInt8), symbol_name : Pointer(UInt8), message : Pointer(UInt8), is_error : Int32) : Void

  struct ScannerConfig # struct
    cset_skip_characters : Pointer(UInt8)
    cset_identifier_first : Pointer(UInt8)
    cset_identifier_nth : Pointer(UInt8)
    cpair_comment_single : Pointer(UInt8)
    case_sensitive : UInt32
    skip_comment_multi : UInt32
    skip_comment_single : UInt32
    scan_comment_multi : UInt32
    scan_identifier : UInt32
    scan_identifier_1char : UInt32
    scan_identifier_NULL : UInt32
    scan_symbols : UInt32
    scan_binary : UInt32
    scan_octal : UInt32
    scan_float : UInt32
    scan_hex : UInt32
    scan_hex_dollar : UInt32
    scan_string_sq : UInt32
    scan_string_dq : UInt32
    numbers_2_int : UInt32
    int_2_float : UInt32
    identifier_2_string : UInt32
    char_2_token : UInt32
    symbol_2_token : UInt32
    scope_0_fallback : UInt32
    store_int64 : UInt32
    padding_dummy : UInt32
  end

  struct Sequence # struct
    _data : UInt8[0]
  end
  fun g_sequence_append(this : Sequence*, data : Pointer(Void)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_free(this : Sequence*) : Void
  fun g_sequence_get_begin_iter(this : Sequence*) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_get_end_iter(this : Sequence*) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_get_iter_at_pos(this : Sequence*, pos : Int32) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_get_length(this : Sequence*) : Int32
  fun g_sequence_is_empty(this : Sequence*) : LibC::Int
  fun g_sequence_prepend(this : Sequence*, data : Pointer(Void)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_get(iter : Pointer(LibGLib::SequenceIter)) : Pointer(Void)
  fun g_sequence_insert_before(iter : Pointer(LibGLib::SequenceIter), data : Pointer(Void)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_move(src : Pointer(LibGLib::SequenceIter), dest : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_move_range(dest : Pointer(LibGLib::SequenceIter), _begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_range_get_midpoint(_begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_remove(iter : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_remove_range(_begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_set(iter : Pointer(LibGLib::SequenceIter), data : Pointer(Void)) : Void
  fun g_sequence_swap(a : Pointer(LibGLib::SequenceIter), b : Pointer(LibGLib::SequenceIter)) : Void

  struct SequenceIter # struct
    _data : UInt8[0]
  end
  fun g_sequence_iter_compare(this : SequenceIter*, b : Pointer(LibGLib::SequenceIter)) : Int32
  fun g_sequence_iter_get_position(this : SequenceIter*) : Int32
  fun g_sequence_iter_get_sequence(this : SequenceIter*) : Pointer(LibGLib::Sequence)
  fun g_sequence_iter_is_begin(this : SequenceIter*) : LibC::Int
  fun g_sequence_iter_is_end(this : SequenceIter*) : LibC::Int
  fun g_sequence_iter_move(this : SequenceIter*, delta : Int32) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_iter_next(this : SequenceIter*) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_iter_prev(this : SequenceIter*) : Pointer(LibGLib::SequenceIter)

  struct Source # struct
    callback_data : Pointer(Void)
    callback_funcs : Pointer(LibGLib::SourceCallbackFuncs)
    source_funcs : Pointer(LibGLib::SourceFuncs)
    ref_count : UInt32
    context : Pointer(LibGLib::MainContext)
    priority : Int32
    flags : UInt32
    source_id : UInt32
    poll_fds : Pointer(Void*)
    prev : Pointer(LibGLib::Source)
    _next : Pointer(LibGLib::Source)
    name : Pointer(UInt8)
    priv : Pointer(LibGLib::SourcePrivate)
  end
  fun g_source_get_type : UInt64
  fun g_source_new(source_funcs : Pointer(LibGLib::SourceFuncs), struct_size : UInt32) : Pointer(LibGLib::Source)
  fun g_source_add_child_source(this : Source*, child_source : Pointer(LibGLib::Source)) : Void
  fun g_source_add_poll(this : Source*, fd : Pointer(LibGLib::PollFD)) : Void
  fun g_source_add_unix_fd(this : Source*, fd : Int32, events : LibGLib::IOCondition) : Pointer(Void)
  fun g_source_attach(this : Source*, context : Pointer(LibGLib::MainContext)) : UInt32
  fun g_source_destroy(this : Source*) : Void
  fun g_source_get_can_recurse(this : Source*) : LibC::Int
  fun g_source_get_context(this : Source*) : Pointer(LibGLib::MainContext)
  fun g_source_get_current_time(this : Source*, timeval : Pointer(LibGLib::TimeVal)) : Void
  fun g_source_get_id(this : Source*) : UInt32
  fun g_source_get_name(this : Source*) : Pointer(UInt8)
  fun g_source_get_priority(this : Source*) : Int32
  fun g_source_get_ready_time(this : Source*) : Int64
  fun g_source_get_time(this : Source*) : Int64
  fun g_source_is_destroyed(this : Source*) : LibC::Int
  fun g_source_modify_unix_fd(this : Source*, tag : Pointer(Void), new_events : LibGLib::IOCondition) : Void
  fun g_source_query_unix_fd(this : Source*, tag : Pointer(Void)) : LibGLib::IOCondition
  fun g_source_ref(this : Source*) : Pointer(LibGLib::Source)
  fun g_source_remove_child_source(this : Source*, child_source : Pointer(LibGLib::Source)) : Void
  fun g_source_remove_poll(this : Source*, fd : Pointer(LibGLib::PollFD)) : Void
  fun g_source_remove_unix_fd(this : Source*, tag : Pointer(Void)) : Void
  fun g_source_set_callback(this : Source*, func : LibGLib::SourceFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : Void
  fun g_source_set_callback_indirect(this : Source*, callback_data : Pointer(Void), callback_funcs : Pointer(LibGLib::SourceCallbackFuncs)) : Void
  fun g_source_set_can_recurse(this : Source*, can_recurse : LibC::Int) : Void
  fun g_source_set_funcs(this : Source*, funcs : Pointer(LibGLib::SourceFuncs)) : Void
  fun g_source_set_name(this : Source*, name : Pointer(UInt8)) : Void
  fun g_source_set_priority(this : Source*, priority : Int32) : Void
  fun g_source_set_ready_time(this : Source*, ready_time : Int64) : Void
  fun g_source_unref(this : Source*) : Void
  fun g_source_remove(tag : UInt32) : LibC::Int
  fun g_source_remove_by_funcs_user_data(funcs : Pointer(LibGLib::SourceFuncs), user_data : Pointer(Void)) : LibC::Int
  fun g_source_remove_by_user_data(user_data : Pointer(Void)) : LibC::Int
  fun g_source_set_name_by_id(tag : UInt32, name : Pointer(UInt8)) : Void

  struct SourceCallbackFuncs # struct
    ref : Pointer(Void) -> Void
    unref : Pointer(Void) -> Void
    get : Pointer(Void)
  end

  struct SourceFuncs # struct
    prepare : Pointer(LibGLib::Source), Pointer(Int32) -> LibC::Int
    check : Pointer(LibGLib::Source) -> LibC::Int
    dispatch : Pointer(Void)
    finalize : Pointer(LibGLib::Source) -> Void
    closure_callback : LibGLib::SourceFunc
    closure_marshal : LibGLib::SourceDummyMarshal
  end

  struct SourcePrivate # struct
    _data : UInt8[0]
  end

  struct StatBuf # struct
    _data : UInt8[0]
  end

  struct String # struct
    str : Pointer(UInt8)
    len : UInt64
    allocated_len : UInt64
  end
  fun g_gstring_get_type : UInt64
  fun g_string_append(this : String*, val : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_append_c(this : String*, c : Int8) : Pointer(LibGLib::String)
  fun g_string_append_len(this : String*, val : Pointer(UInt8), len : Int64) : Pointer(LibGLib::String)
  fun g_string_append_unichar(this : String*, wc : UInt8) : Pointer(LibGLib::String)
  fun g_string_append_uri_escaped(this : String*, unescaped : Pointer(UInt8), reserved_chars_allowed : Pointer(UInt8), allow_utf8 : LibC::Int) : Pointer(LibGLib::String)
  fun g_string_ascii_down(this : String*) : Pointer(LibGLib::String)
  fun g_string_ascii_up(this : String*) : Pointer(LibGLib::String)
  fun g_string_assign(this : String*, rval : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_down(this : String*) : Pointer(LibGLib::String)
  fun g_string_equal(this : String*, v2 : Pointer(LibGLib::String)) : LibC::Int
  fun g_string_erase(this : String*, pos : Int64, len : Int64) : Pointer(LibGLib::String)
  fun g_string_free(this : String*, free_segment : LibC::Int) : Pointer(UInt8)
  fun g_string_free_to_bytes(this : String*) : Pointer(LibGLib::Bytes)
  fun g_string_hash(this : String*) : UInt32
  fun g_string_insert(this : String*, pos : Int64, val : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_insert_c(this : String*, pos : Int64, c : Int8) : Pointer(LibGLib::String)
  fun g_string_insert_len(this : String*, pos : Int64, val : Pointer(UInt8), len : Int64) : Pointer(LibGLib::String)
  fun g_string_insert_unichar(this : String*, pos : Int64, wc : UInt8) : Pointer(LibGLib::String)
  fun g_string_overwrite(this : String*, pos : UInt64, val : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_overwrite_len(this : String*, pos : UInt64, val : Pointer(UInt8), len : Int64) : Pointer(LibGLib::String)
  fun g_string_prepend(this : String*, val : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_prepend_c(this : String*, c : Int8) : Pointer(LibGLib::String)
  fun g_string_prepend_len(this : String*, val : Pointer(UInt8), len : Int64) : Pointer(LibGLib::String)
  fun g_string_prepend_unichar(this : String*, wc : UInt8) : Pointer(LibGLib::String)
  fun g_string_replace(this : String*, find : Pointer(UInt8), replace : Pointer(UInt8), limit : UInt32) : UInt32
  fun g_string_set_size(this : String*, len : UInt64) : Pointer(LibGLib::String)
  fun g_string_truncate(this : String*, len : UInt64) : Pointer(LibGLib::String)
  fun g_string_up(this : String*) : Pointer(LibGLib::String)

  struct StringChunk # struct
    _data : UInt8[0]
  end
  fun g_string_chunk_clear(this : StringChunk*) : Void
  fun g_string_chunk_free(this : StringChunk*) : Void
  fun g_string_chunk_insert(this : StringChunk*, string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_string_chunk_insert_const(this : StringChunk*, string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_string_chunk_insert_len(this : StringChunk*, string : Pointer(UInt8), len : Int64) : Pointer(UInt8)

  struct StrvBuilder # struct
    _data : UInt8[0]
  end
  fun g_strv_builder_add(this : StrvBuilder*, value : Pointer(UInt8)) : Void
  fun g_strv_builder_end(this : StrvBuilder*) : Pointer(Pointer(UInt8))
  fun g_strv_builder_unref(this : StrvBuilder*) : Void

  struct TestCase # struct
    _data : UInt8[0]
  end

  struct TestConfig # struct
    test_initialized : LibC::Int
    test_quick : LibC::Int
    test_perf : LibC::Int
    test_verbose : LibC::Int
    test_quiet : LibC::Int
    test_undefined : LibC::Int
  end

  struct TestLogBuffer # struct
    data : Pointer(LibGLib::String)
    msgs : Pointer(Void*)
  end
  fun g_test_log_buffer_free(this : TestLogBuffer*) : Void
  fun g_test_log_buffer_push(this : TestLogBuffer*, n_bytes : UInt32, bytes : Pointer(UInt8)) : Void

  struct TestLogMsg # struct
    log_type : LibGLib::TestLogType
    n_strings : UInt32
    strings : Pointer(UInt8)
    n_nums : UInt32
    nums : Pointer(Void)
  end
  fun g_test_log_msg_free(this : TestLogMsg*) : Void

  struct TestSuite # struct
    _data : UInt8[0]
  end
  fun g_test_suite_add(this : TestSuite*, test_case : Pointer(LibGLib::TestCase)) : Void
  fun g_test_suite_add_suite(this : TestSuite*, nestedsuite : Pointer(LibGLib::TestSuite)) : Void

  struct Thread # struct
    _data : UInt8[0]
  end
  fun g_thread_get_type : UInt64
  fun g_thread_new(name : Pointer(UInt8), func : LibGLib::ThreadFunc, data : Pointer(Void)) : Pointer(LibGLib::Thread)
  fun g_thread_try_new(name : Pointer(UInt8), func : LibGLib::ThreadFunc, data : Pointer(Void), error : LibGLib::Error**) : Pointer(LibGLib::Thread)
  fun g_thread_join(this : Thread*) : Pointer(Void)
  fun g_thread_ref(this : Thread*) : Pointer(LibGLib::Thread)
  fun g_thread_unref(this : Thread*) : Void
  fun g_thread_error_quark : UInt32
  fun g_thread_exit(retval : Pointer(Void)) : Void
  fun g_thread_self : Pointer(LibGLib::Thread)
  fun g_thread_yield : Void

  struct ThreadPool # struct
    func : LibGLib::Func
    user_data : Pointer(Void)
    exclusive : LibC::Int
  end
  fun g_thread_pool_free(this : ThreadPool*, immediate : LibC::Int, wait_ : LibC::Int) : Void
  fun g_thread_pool_get_max_threads(this : ThreadPool*) : Int32
  fun g_thread_pool_get_num_threads(this : ThreadPool*) : UInt32
  fun g_thread_pool_move_to_front(this : ThreadPool*, data : Pointer(Void)) : LibC::Int
  fun g_thread_pool_push(this : ThreadPool*, data : Pointer(Void), error : LibGLib::Error**) : LibC::Int
  fun g_thread_pool_set_max_threads(this : ThreadPool*, max_threads : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_thread_pool_unprocessed(this : ThreadPool*) : UInt32
  fun g_thread_pool_get_max_idle_time : UInt32
  fun g_thread_pool_get_max_unused_threads : Int32
  fun g_thread_pool_get_num_unused_threads : UInt32
  fun g_thread_pool_set_max_idle_time(interval : UInt32) : Void
  fun g_thread_pool_set_max_unused_threads(max_threads : Int32) : Void
  fun g_thread_pool_stop_unused_threads : Void

  struct TimeVal # struct
    tv_sec : Int64
    tv_usec : Int64
  end
  fun g_time_val_add(this : TimeVal*, microseconds : Int64) : Void
  fun g_time_val_to_iso8601(this : TimeVal*) : Pointer(UInt8)
  fun g_time_val_from_iso8601(iso_date : Pointer(UInt8), time_ : LibGLib::TimeVal*) : LibC::Int

  struct TimeZone # struct
    _data : UInt8[0]
  end
  fun g_time_zone_get_type : UInt64
  fun g_time_zone_new(identifier : Pointer(UInt8)) : Pointer(LibGLib::TimeZone)
  fun g_time_zone_new_identifier(identifier : Pointer(UInt8)) : Pointer(LibGLib::TimeZone)
  fun g_time_zone_new_local : Pointer(LibGLib::TimeZone)
  fun g_time_zone_new_offset(seconds : Int32) : Pointer(LibGLib::TimeZone)
  fun g_time_zone_new_utc : Pointer(LibGLib::TimeZone)
  fun g_time_zone_adjust_time(this : TimeZone*, type : LibGLib::TimeType, time_ : Pointer(Int64)) : Int32
  fun g_time_zone_find_interval(this : TimeZone*, type : LibGLib::TimeType, time_ : Int64) : Int32
  fun g_time_zone_get_abbreviation(this : TimeZone*, interval : Int32) : Pointer(UInt8)
  fun g_time_zone_get_identifier(this : TimeZone*) : Pointer(UInt8)
  fun g_time_zone_get_offset(this : TimeZone*, interval : Int32) : Int32
  fun g_time_zone_is_dst(this : TimeZone*, interval : Int32) : LibC::Int
  fun g_time_zone_ref(this : TimeZone*) : Pointer(LibGLib::TimeZone)
  fun g_time_zone_unref(this : TimeZone*) : Void

  struct Timer # struct
    _data : UInt8[0]
  end
  fun g_timer_continue(this : Timer*) : Void
  fun g_timer_destroy(this : Timer*) : Void
  fun g_timer_elapsed(this : Timer*, microseconds : Pointer(UInt64)) : Float64
  fun g_timer_is_active(this : Timer*) : LibC::Int
  fun g_timer_reset(this : Timer*) : Void
  fun g_timer_start(this : Timer*) : Void
  fun g_timer_stop(this : Timer*) : Void

  struct TrashStack # struct
    _next : Pointer(LibGLib::TrashStack)
  end
  fun g_trash_stack_height(stack_p : Pointer(LibGLib::TrashStack)) : UInt32
  fun g_trash_stack_peek(stack_p : Pointer(LibGLib::TrashStack)) : Pointer(Void)
  fun g_trash_stack_pop(stack_p : Pointer(LibGLib::TrashStack)) : Pointer(Void)
  fun g_trash_stack_push(stack_p : Pointer(LibGLib::TrashStack), data_p : Pointer(Void)) : Void

  struct Tree # struct
    _data : UInt8[0]
  end
  fun g_tree_get_type : UInt64
  fun g_tree_new_full(key_compare_func : LibGLib::CompareDataFunc, key_compare_data : Pointer(Void), key_destroy_func : LibGLib::DestroyNotify, value_destroy_func : LibGLib::DestroyNotify) : Pointer(LibGLib::Tree)
  fun g_tree_destroy(this : Tree*) : Void
  fun g_tree_height(this : Tree*) : Int32
  fun g_tree_insert(this : Tree*, key : Pointer(Void), value : Pointer(Void)) : Void
  fun g_tree_insert_node(this : Tree*, key : Pointer(Void), value : Pointer(Void)) : Pointer(LibGLib::TreeNode)
  fun g_tree_lookup(this : Tree*, key : Pointer(Void)) : Pointer(Void)
  fun g_tree_lookup_extended(this : Tree*, lookup_key : Pointer(Void), orig_key : Pointer(Void)*, value : Pointer(Void)*) : LibC::Int
  fun g_tree_lookup_node(this : Tree*, key : Pointer(Void)) : Pointer(LibGLib::TreeNode)
  fun g_tree_lower_bound(this : Tree*, key : Pointer(Void)) : Pointer(LibGLib::TreeNode)
  fun g_tree_nnodes(this : Tree*) : Int32
  fun g_tree_node_first(this : Tree*) : Pointer(LibGLib::TreeNode)
  fun g_tree_node_last(this : Tree*) : Pointer(LibGLib::TreeNode)
  fun g_tree_ref(this : Tree*) : Pointer(LibGLib::Tree)
  fun g_tree_remove(this : Tree*, key : Pointer(Void)) : LibC::Int
  fun g_tree_replace(this : Tree*, key : Pointer(Void), value : Pointer(Void)) : Void
  fun g_tree_replace_node(this : Tree*, key : Pointer(Void), value : Pointer(Void)) : Pointer(LibGLib::TreeNode)
  fun g_tree_steal(this : Tree*, key : Pointer(Void)) : LibC::Int
  fun g_tree_unref(this : Tree*) : Void
  fun g_tree_upper_bound(this : Tree*, key : Pointer(Void)) : Pointer(LibGLib::TreeNode)

  struct TreeNode # struct
    _data : UInt8[0]
  end
  fun g_tree_node_key(this : TreeNode*) : Pointer(Void)
  fun g_tree_node_next(this : TreeNode*) : Pointer(LibGLib::TreeNode)
  fun g_tree_node_previous(this : TreeNode*) : Pointer(LibGLib::TreeNode)
  fun g_tree_node_value(this : TreeNode*) : Pointer(Void)

  struct Uri # struct
    _data : UInt8[0]
  end
  fun g_uri_get_type : UInt64
  fun g_uri_get_auth_params(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_flags(this : Uri*) : LibGLib::UriFlags
  fun g_uri_get_fragment(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_host(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_password(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_path(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_port(this : Uri*) : Int32
  fun g_uri_get_query(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_scheme(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_user(this : Uri*) : Pointer(UInt8)
  fun g_uri_get_userinfo(this : Uri*) : Pointer(UInt8)
  fun g_uri_parse_relative(this : Uri*, uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : Pointer(LibGLib::Uri)
  fun g_uri_to_string(this : Uri*) : Pointer(UInt8)
  fun g_uri_to_string_partial(this : Uri*, flags : LibGLib::UriHideFlags) : Pointer(UInt8)
  fun g_uri_build(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), userinfo : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(LibGLib::Uri)
  fun g_uri_build_with_user(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), user : Pointer(UInt8), password : Pointer(UInt8), auth_params : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(LibGLib::Uri)
  fun g_uri_error_quark : UInt32
  fun g_uri_escape_bytes(unescaped : Pointer(UInt8), length : UInt64, reserved_chars_allowed : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_escape_string(unescaped : Pointer(UInt8), reserved_chars_allowed : Pointer(UInt8), allow_utf8 : LibC::Int) : Pointer(UInt8)
  fun g_uri_is_valid(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : LibC::Int
  fun g_uri_join(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), userinfo : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_join_with_user(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), user : Pointer(UInt8), password : Pointer(UInt8), auth_params : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_list_extract_uris(uri_list : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_uri_parse(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : Pointer(LibGLib::Uri)
  fun g_uri_parse_params(params : Pointer(UInt8), length : Int64, separators : Pointer(UInt8), flags : LibGLib::UriParamsFlags, error : LibGLib::Error**) : Pointer(Void*)
  fun g_uri_parse_scheme(uri : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_peek_scheme(uri : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_resolve_relative(base_uri_string : Pointer(UInt8), uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_uri_split(uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, userinfo : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, path : Pointer(UInt8)*, query : Pointer(UInt8)*, fragment : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_split_network(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_split_with_user(uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, user : Pointer(UInt8)*, password : Pointer(UInt8)*, auth_params : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, path : Pointer(UInt8)*, query : Pointer(UInt8)*, fragment : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_unescape_bytes(escaped_string : Pointer(UInt8), length : Int64, illegal_characters : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::Bytes)
  fun g_uri_unescape_segment(escaped_string : Pointer(UInt8), escaped_string_end : Pointer(UInt8), illegal_characters : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_unescape_string(escaped_string : Pointer(UInt8), illegal_characters : Pointer(UInt8)) : Pointer(UInt8)

  struct UriParamsIter # struct
    dummy0 : Int32
    dummy1 : Pointer(Void)
    dummy2 : Pointer(Void)
    dummy3 : UInt8[256]
  end
  fun g_uri_params_iter_init(this : UriParamsIter*, params : Pointer(UInt8), length : Int64, separators : Pointer(UInt8), flags : LibGLib::UriParamsFlags) : Void
  fun g_uri_params_iter_next(this : UriParamsIter*, attribute : Pointer(UInt8)*, value : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int

  struct Variant # struct
    _data : UInt8[0]
  end
  fun g_variant_new_array(child_type : Pointer(LibGLib::VariantType), children : Pointer(Pointer(LibGLib::Variant)), n_children : UInt64) : Pointer(LibGLib::Variant)
  fun g_variant_new_boolean(value : LibC::Int) : Pointer(LibGLib::Variant)
  fun g_variant_new_byte(value : UInt8) : Pointer(LibGLib::Variant)
  fun g_variant_new_bytestring(string : Pointer(UInt8)) : Pointer(LibGLib::Variant)
  fun g_variant_new_bytestring_array(strv : Pointer(Pointer(UInt8)), length : Int64) : Pointer(LibGLib::Variant)
  fun g_variant_new_dict_entry(key : Pointer(LibGLib::Variant), value : Pointer(LibGLib::Variant)) : Pointer(LibGLib::Variant)
  fun g_variant_new_double(value : Float64) : Pointer(LibGLib::Variant)
  fun g_variant_new_fixed_array(element_type : Pointer(LibGLib::VariantType), elements : Pointer(Void), n_elements : UInt64, element_size : UInt64) : Pointer(LibGLib::Variant)
  fun g_variant_new_from_bytes(type : Pointer(LibGLib::VariantType), bytes : Pointer(LibGLib::Bytes), trusted : LibC::Int) : Pointer(LibGLib::Variant)
  fun g_variant_new_from_data(type : Pointer(LibGLib::VariantType), data : Pointer(UInt8), size : UInt64, trusted : LibC::Int, notify : LibGLib::DestroyNotify, user_data : Pointer(Void)) : Pointer(LibGLib::Variant)
  fun g_variant_new_handle(value : Int32) : Pointer(LibGLib::Variant)
  fun g_variant_new_int16(value : Int16) : Pointer(LibGLib::Variant)
  fun g_variant_new_int32(value : Int32) : Pointer(LibGLib::Variant)
  fun g_variant_new_int64(value : Int64) : Pointer(LibGLib::Variant)
  fun g_variant_new_maybe(child_type : Pointer(LibGLib::VariantType), child : Pointer(LibGLib::Variant)) : Pointer(LibGLib::Variant)
  fun g_variant_new_object_path(object_path : Pointer(UInt8)) : Pointer(LibGLib::Variant)
  fun g_variant_new_objv(strv : Pointer(Pointer(UInt8)), length : Int64) : Pointer(LibGLib::Variant)
  fun g_variant_new_signature(signature : Pointer(UInt8)) : Pointer(LibGLib::Variant)
  fun g_variant_new_string(string : Pointer(UInt8)) : Pointer(LibGLib::Variant)
  fun g_variant_new_strv(strv : Pointer(Pointer(UInt8)), length : Int64) : Pointer(LibGLib::Variant)
  fun g_variant_new_tuple(children : Pointer(Pointer(LibGLib::Variant)), n_children : UInt64) : Pointer(LibGLib::Variant)
  fun g_variant_new_uint16(value : UInt16) : Pointer(LibGLib::Variant)
  fun g_variant_new_uint32(value : UInt32) : Pointer(LibGLib::Variant)
  fun g_variant_new_uint64(value : UInt64) : Pointer(LibGLib::Variant)
  fun g_variant_new_variant(value : Pointer(LibGLib::Variant)) : Pointer(LibGLib::Variant)
  fun g_variant_byteswap(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_check_format_string(this : Variant*, format_string : Pointer(UInt8), copy_only : LibC::Int) : LibC::Int
  fun g_variant_classify(this : Variant*) : LibGLib::VariantClass
  fun g_variant_compare(this : Variant*, two : Pointer(LibGLib::Variant)) : Int32
  fun g_variant_dup_bytestring(this : Variant*, length : UInt64*) : Pointer(UInt8)
  fun g_variant_dup_bytestring_array(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_dup_objv(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_dup_string(this : Variant*, length : UInt64*) : Pointer(UInt8)
  fun g_variant_dup_strv(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_equal(this : Variant*, two : Pointer(LibGLib::Variant)) : LibC::Int
  fun g_variant_get_boolean(this : Variant*) : LibC::Int
  fun g_variant_get_byte(this : Variant*) : UInt8
  fun g_variant_get_bytestring(this : Variant*) : Pointer(UInt8)
  fun g_variant_get_bytestring_array(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_get_child_value(this : Variant*, index_ : UInt64) : Pointer(LibGLib::Variant)
  fun g_variant_get_data(this : Variant*) : Pointer(Void)
  fun g_variant_get_data_as_bytes(this : Variant*) : Pointer(LibGLib::Bytes)
  fun g_variant_get_double(this : Variant*) : Float64
  fun g_variant_get_handle(this : Variant*) : Int32
  fun g_variant_get_int16(this : Variant*) : Int16
  fun g_variant_get_int32(this : Variant*) : Int32
  fun g_variant_get_int64(this : Variant*) : Int64
  fun g_variant_get_maybe(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_get_normal_form(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_get_objv(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_get_size(this : Variant*) : UInt64
  fun g_variant_get_string(this : Variant*, length : UInt64*) : Pointer(UInt8)
  fun g_variant_get_strv(this : Variant*, length : UInt64*) : Pointer(Pointer(UInt8))
  fun g_variant_get_type(this : Variant*) : Pointer(LibGLib::VariantType)
  fun g_variant_get_type_string(this : Variant*) : Pointer(UInt8)
  fun g_variant_get_uint16(this : Variant*) : UInt16
  fun g_variant_get_uint32(this : Variant*) : UInt32
  fun g_variant_get_uint64(this : Variant*) : UInt64
  fun g_variant_get_variant(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_hash(this : Variant*) : UInt32
  fun g_variant_is_container(this : Variant*) : LibC::Int
  fun g_variant_is_floating(this : Variant*) : LibC::Int
  fun g_variant_is_normal_form(this : Variant*) : LibC::Int
  fun g_variant_is_of_type(this : Variant*, type : Pointer(LibGLib::VariantType)) : LibC::Int
  fun g_variant_lookup_value(this : Variant*, key : Pointer(UInt8), expected_type : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::Variant)
  fun g_variant_n_children(this : Variant*) : UInt64
  fun g_variant_print(this : Variant*, type_annotate : LibC::Int) : Pointer(UInt8)
  fun g_variant_ref(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_ref_sink(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_store(this : Variant*, data : Pointer(Void)) : Void
  fun g_variant_take_ref(this : Variant*) : Pointer(LibGLib::Variant)
  fun g_variant_unref(this : Variant*) : Void
  fun g_variant_is_object_path(string : Pointer(UInt8)) : LibC::Int
  fun g_variant_is_signature(string : Pointer(UInt8)) : LibC::Int
  fun g_variant_parse(type : Pointer(LibGLib::VariantType), text : Pointer(UInt8), limit : Pointer(UInt8), endptr : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::Variant)
  fun g_variant_parse_error_print_context(error : Pointer(LibGLib::Error*), source_str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_variant_parse_error_quark : UInt32
  fun g_variant_parser_get_error_quark : UInt32

  struct VariantBuilder # struct
    _data : UInt8[0]
  end
  fun g_variant_builder_get_type : UInt64
  fun g_variant_builder_new(type : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::VariantBuilder)
  fun g_variant_builder_add_value(this : VariantBuilder*, value : Pointer(LibGLib::Variant)) : Void
  fun g_variant_builder_close(this : VariantBuilder*) : Void
  fun g_variant_builder_end(this : VariantBuilder*) : Pointer(LibGLib::Variant)
  fun g_variant_builder_open(this : VariantBuilder*, type : Pointer(LibGLib::VariantType)) : Void
  fun g_variant_builder_ref(this : VariantBuilder*) : Pointer(LibGLib::VariantBuilder)
  fun g_variant_builder_unref(this : VariantBuilder*) : Void

  struct VariantDict # struct
    _data : UInt8[0]
  end
  fun g_variant_dict_get_type : UInt64
  fun g_variant_dict_new(from_asv : Pointer(LibGLib::Variant)) : Pointer(LibGLib::VariantDict)
  fun g_variant_dict_clear(this : VariantDict*) : Void
  fun g_variant_dict_contains(this : VariantDict*, key : Pointer(UInt8)) : LibC::Int
  fun g_variant_dict_end(this : VariantDict*) : Pointer(LibGLib::Variant)
  fun g_variant_dict_insert_value(this : VariantDict*, key : Pointer(UInt8), value : Pointer(LibGLib::Variant)) : Void
  fun g_variant_dict_lookup_value(this : VariantDict*, key : Pointer(UInt8), expected_type : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::Variant)
  fun g_variant_dict_ref(this : VariantDict*) : Pointer(LibGLib::VariantDict)
  fun g_variant_dict_remove(this : VariantDict*, key : Pointer(UInt8)) : LibC::Int
  fun g_variant_dict_unref(this : VariantDict*) : Void

  struct VariantType # struct
    _data : UInt8[0]
  end
  fun g_variant_type_get_gtype : UInt64
  fun g_variant_type_new(type_string : Pointer(UInt8)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_new_array(element : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_new_dict_entry(key : Pointer(LibGLib::VariantType), value : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_new_maybe(element : Pointer(LibGLib::VariantType)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_new_tuple(items : Pointer(Pointer(LibGLib::VariantType)), length : Int32) : Pointer(LibGLib::VariantType)
  fun g_variant_type_copy(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_dup_string(this : VariantType*) : Pointer(UInt8)
  fun g_variant_type_element(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_equal(this : VariantType*, type2 : Pointer(LibGLib::VariantType)) : LibC::Int
  fun g_variant_type_first(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_free(this : VariantType*) : Void
  fun g_variant_type_get_string_length(this : VariantType*) : UInt64
  fun g_variant_type_hash(this : VariantType*) : UInt32
  fun g_variant_type_is_array(this : VariantType*) : LibC::Int
  fun g_variant_type_is_basic(this : VariantType*) : LibC::Int
  fun g_variant_type_is_container(this : VariantType*) : LibC::Int
  fun g_variant_type_is_definite(this : VariantType*) : LibC::Int
  fun g_variant_type_is_dict_entry(this : VariantType*) : LibC::Int
  fun g_variant_type_is_maybe(this : VariantType*) : LibC::Int
  fun g_variant_type_is_subtype_of(this : VariantType*, supertype : Pointer(LibGLib::VariantType)) : LibC::Int
  fun g_variant_type_is_tuple(this : VariantType*) : LibC::Int
  fun g_variant_type_is_variant(this : VariantType*) : LibC::Int
  fun g_variant_type_key(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_n_items(this : VariantType*) : UInt64
  fun g_variant_type_next(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_value(this : VariantType*) : Pointer(LibGLib::VariantType)
  fun g_variant_type_checked_(arg0 : Pointer(UInt8)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_string_get_depth_(type_string : Pointer(UInt8)) : UInt64
  fun g_variant_type_string_is_valid(type_string : Pointer(UInt8)) : LibC::Int
  fun g_variant_type_string_scan(string : Pointer(UInt8), limit : Pointer(UInt8), endptr : Pointer(UInt8)*) : LibC::Int

  ###########################################
  ##    Flags
  ###########################################

  alias AsciiType = UInt32

  alias FileSetContentsFlags = UInt32

  alias FileTest = UInt32

  alias FormatSizeFlags = UInt32

  alias HookFlagMask = UInt32

  alias IOCondition = UInt32

  alias IOFlags = UInt32

  alias KeyFileFlags = UInt32

  alias LogLevelFlags = Int32

  alias MarkupCollectType = UInt32

  alias MarkupParseFlags = UInt32

  alias OptionFlags = UInt32

  alias RegexCompileFlags = UInt32

  alias RegexMatchFlags = UInt32

  alias SpawnFlags = UInt32

  alias TestSubprocessFlags = UInt32

  alias TestTrapFlags = UInt32

  alias TraverseFlags = UInt32

  alias UriFlags = UInt32

  alias UriHideFlags = UInt32

  alias UriParamsFlags = UInt32

  ###########################################
  ##    Enums
  ###########################################

  alias BookmarkFileError = UInt32

  alias ChecksumType = UInt32

  alias ConvertError = UInt32

  alias DateDMY = UInt32

  alias DateMonth = UInt32

  alias DateWeekday = UInt32

  alias ErrorType = UInt32

  alias FileError = UInt32

  alias IOChannelError = UInt32

  alias IOError = UInt32

  alias IOStatus = UInt32

  alias KeyFileError = UInt32

  alias LogWriterOutput = UInt32

  alias MarkupError = UInt32

  alias NormalizeMode = UInt32

  alias NumberParserError = UInt32

  alias OnceStatus = UInt32

  alias OptionArg = UInt32

  alias OptionError = UInt32

  alias RegexError = UInt32

  alias SeekType = UInt32

  alias ShellError = UInt32

  alias SliceConfig = UInt32

  alias SpawnError = UInt32

  alias TestFileType = UInt32

  alias TestLogType = UInt32

  alias TestResult = UInt32

  alias ThreadError = UInt32

  alias TimeType = UInt32

  alias TokenType = UInt32

  alias TraverseType = UInt32

  alias UnicodeBreakType = UInt32

  alias UnicodeScript = Int32

  alias UnicodeType = UInt32

  alias UriError = UInt32

  alias UserDirectory = UInt32

  alias VariantClass = UInt32

  alias VariantParseError = UInt32

  ###########################################
  ##    Unions
  ###########################################

  union DoubleIEEE754
    v_double : Float64
  end

  union FloatIEEE754
    v_float : Float32
  end

  union Mutex
    p : Pointer(Void)
    i : UInt32[2]
  end
  fun g_mutex_clear(this : Mutex*) : Void
  fun g_mutex_init(this : Mutex*) : Void
  fun g_mutex_lock(this : Mutex*) : Void
  fun g_mutex_trylock(this : Mutex*) : LibC::Int
  fun g_mutex_unlock(this : Mutex*) : Void

  union TokenValue
    v_symbol : Pointer(Void)
    v_identifier : Pointer(UInt8)
    v_binary : UInt64
    v_octal : UInt64
    v_int : UInt64
    v_int64 : UInt64
    v_float : Float64
    v_hex : UInt64
    v_string : Pointer(UInt8)
    v_comment : Pointer(UInt8)
    v_char : UInt8
    v_error : UInt32
  end

  ###########################################
  ##    Functions
  ###########################################
  fun g_access(filename : Pointer(UInt8), mode : Int32) : Int32
  fun g_ascii_digit_value(c : Int8) : Int32
  fun g_ascii_dtostr(buffer : Pointer(UInt8), buf_len : Int32, d : Float64) : Pointer(UInt8)
  fun g_ascii_formatd(buffer : Pointer(UInt8), buf_len : Int32, format : Pointer(UInt8), d : Float64) : Pointer(UInt8)
  fun g_ascii_strcasecmp(s1 : Pointer(UInt8), s2 : Pointer(UInt8)) : Int32
  fun g_ascii_strdown(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_ascii_string_to_signed(str : Pointer(UInt8), base : UInt32, min : Int64, max : Int64, out_num : Int64*, error : LibGLib::Error**) : LibC::Int
  fun g_ascii_string_to_unsigned(str : Pointer(UInt8), base : UInt32, min : UInt64, max : UInt64, out_num : UInt64*, error : LibGLib::Error**) : LibC::Int
  fun g_ascii_strncasecmp(s1 : Pointer(UInt8), s2 : Pointer(UInt8), n : UInt64) : Int32
  fun g_ascii_strtod(nptr : Pointer(UInt8), endptr : Pointer(UInt8)*) : Float64
  fun g_ascii_strtoll(nptr : Pointer(UInt8), endptr : Pointer(UInt8)*, base : UInt32) : Int64
  fun g_ascii_strtoull(nptr : Pointer(UInt8), endptr : Pointer(UInt8)*, base : UInt32) : UInt64
  fun g_ascii_strup(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_ascii_tolower(c : Int8) : Int8
  fun g_ascii_toupper(c : Int8) : Int8
  fun g_ascii_xdigit_value(c : Int8) : Int32
  fun g_assert_warning(log_domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, pretty_function : Pointer(UInt8), expression : Pointer(UInt8)) : Void
  fun g_assertion_message(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8), message : Pointer(UInt8)) : Void
  fun g_assertion_message_cmpstr(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8), expr : Pointer(UInt8), arg1 : Pointer(UInt8), cmp : Pointer(UInt8), arg2 : Pointer(UInt8)) : Void
  fun g_assertion_message_cmpstrv(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8), expr : Pointer(UInt8), arg1 : Pointer(UInt8), arg2 : Pointer(UInt8), first_wrong_idx : UInt64) : Void
  fun g_assertion_message_error(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8), expr : Pointer(UInt8), error : Pointer(LibGLib::Error*), error_domain : UInt32, error_code : Int32) : Void
  fun g_atexit(func : LibGLib::VoidFunc) : Void
  fun g_atomic_int_add(atomic : Pointer(Int32), val : Int32) : Int32
  fun g_atomic_int_and(atomic : Pointer(UInt32), val : UInt32) : UInt32
  fun g_atomic_int_compare_and_exchange(atomic : Pointer(Int32), oldval : Int32, newval : Int32) : LibC::Int
  fun g_atomic_int_dec_and_test(atomic : Pointer(Int32)) : LibC::Int
  fun g_atomic_int_exchange_and_add(atomic : Pointer(Int32), val : Int32) : Int32
  fun g_atomic_int_get(atomic : Pointer(Int32)) : Int32
  fun g_atomic_int_inc(atomic : Pointer(Int32)) : Void
  fun g_atomic_int_or(atomic : Pointer(UInt32), val : UInt32) : UInt32
  fun g_atomic_int_set(atomic : Pointer(Int32), newval : Int32) : Void
  fun g_atomic_int_xor(atomic : Pointer(UInt32), val : UInt32) : UInt32
  fun g_atomic_pointer_add(atomic : Pointer(Void), val : Int64) : Int64
  fun g_atomic_pointer_and(atomic : Pointer(Void), val : UInt64) : UInt64
  fun g_atomic_pointer_compare_and_exchange(atomic : Pointer(Void), oldval : Pointer(Void), newval : Pointer(Void)) : LibC::Int
  fun g_atomic_pointer_get(atomic : Pointer(Void)) : Pointer(Void)
  fun g_atomic_pointer_or(atomic : Pointer(Void), val : UInt64) : UInt64
  fun g_atomic_pointer_set(atomic : Pointer(Void), newval : Pointer(Void)) : Void
  fun g_atomic_pointer_xor(atomic : Pointer(Void), val : UInt64) : UInt64
  fun g_atomic_rc_box_acquire(mem_block : Pointer(Void)) : Pointer(Void)
  fun g_atomic_rc_box_alloc(block_size : UInt64) : Pointer(Void)
  fun g_atomic_rc_box_alloc0(block_size : UInt64) : Pointer(Void)
  fun g_atomic_rc_box_dup(block_size : UInt64, mem_block : Pointer(Void)) : Pointer(Void)
  fun g_atomic_rc_box_get_size(mem_block : Pointer(Void)) : UInt64
  fun g_atomic_rc_box_release(mem_block : Pointer(Void)) : Void
  fun g_atomic_rc_box_release_full(mem_block : Pointer(Void), clear_func : LibGLib::DestroyNotify) : Void
  fun g_atomic_ref_count_compare(arc : Pointer(Int32), val : Int32) : LibC::Int
  fun g_atomic_ref_count_dec(arc : Pointer(Int32)) : LibC::Int
  fun g_atomic_ref_count_inc(arc : Pointer(Int32)) : Void
  fun g_atomic_ref_count_init(arc : Pointer(Int32)) : Void
  fun g_base64_decode(text : Pointer(UInt8), out_len : UInt64*) : Pointer(UInt8)
  fun g_base64_decode_inplace(text : Pointer(UInt8)*, out_len : UInt64*) : Pointer(UInt8)
  fun g_base64_encode(data : Pointer(UInt8), len : UInt64) : Pointer(UInt8)
  fun g_base64_encode_close(break_lines : LibC::Int, _out : Pointer(UInt8)*, state : Int32*, save : Int32*) : UInt64
  fun g_base64_encode_step(_in : Pointer(UInt8), len : UInt64, break_lines : LibC::Int, _out : Pointer(UInt8)*, state : Int32*, save : Int32*) : UInt64
  fun g_basename(file_name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_bit_lock(address : Pointer(Int32), lock_bit : Int32) : Void
  fun g_bit_nth_lsf(mask : UInt64, nth_bit : Int32) : Int32
  fun g_bit_nth_msf(mask : UInt64, nth_bit : Int32) : Int32
  fun g_bit_storage(number : UInt64) : UInt32
  fun g_bit_trylock(address : Pointer(Int32), lock_bit : Int32) : LibC::Int
  fun g_bit_unlock(address : Pointer(Int32), lock_bit : Int32) : Void
  fun g_bookmark_file_error_quark : UInt32
  fun g_build_filenamev(args : Pointer(Pointer(UInt8))) : Pointer(UInt8)
  fun g_build_pathv(separator : Pointer(UInt8), args : Pointer(Pointer(UInt8))) : Pointer(UInt8)
  fun g_byte_array_free(array : Pointer(Void), free_segment : LibC::Int) : Pointer(UInt8)
  fun g_byte_array_free_to_bytes(array : Pointer(Void)) : Pointer(LibGLib::Bytes)
  fun g_byte_array_new : Pointer(Void)
  fun g_byte_array_new_take(data : Pointer(UInt8), len : UInt64) : Pointer(Void)
  fun g_byte_array_steal(array : Pointer(Void), len : UInt64*) : Pointer(UInt8)
  fun g_byte_array_unref(array : Pointer(Void)) : Void
  fun g_canonicalize_filename(filename : Pointer(UInt8), relative_to : Pointer(UInt8)) : Pointer(UInt8)
  fun g_chdir(path : Pointer(UInt8)) : Int32
  fun glib_check_version(required_major : UInt32, required_minor : UInt32, required_micro : UInt32) : Pointer(UInt8)
  fun g_checksum_type_get_length(checksum_type : LibGLib::ChecksumType) : Int64
  fun g_child_watch_add_full(priority : Int32, pid : Int32, function : LibGLib::ChildWatchFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_child_watch_source_new(pid : Int32) : Pointer(LibGLib::Source)
  fun g_clear_error(error : LibGLib::Error**) : Void
  fun g_close(fd : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_compute_checksum_for_bytes(checksum_type : LibGLib::ChecksumType, data : Pointer(LibGLib::Bytes)) : Pointer(UInt8)
  fun g_compute_checksum_for_data(checksum_type : LibGLib::ChecksumType, data : Pointer(UInt8), length : UInt64) : Pointer(UInt8)
  fun g_compute_checksum_for_string(checksum_type : LibGLib::ChecksumType, str : Pointer(UInt8), length : Int64) : Pointer(UInt8)
  fun g_compute_hmac_for_bytes(digest_type : LibGLib::ChecksumType, key : Pointer(LibGLib::Bytes), data : Pointer(LibGLib::Bytes)) : Pointer(UInt8)
  fun g_compute_hmac_for_data(digest_type : LibGLib::ChecksumType, key : Pointer(UInt8), key_len : UInt64, data : Pointer(UInt8), length : UInt64) : Pointer(UInt8)
  fun g_compute_hmac_for_string(digest_type : LibGLib::ChecksumType, key : Pointer(UInt8), key_len : UInt64, str : Pointer(UInt8), length : Int64) : Pointer(UInt8)
  fun g_convert(str : Pointer(UInt8), len : Int64, to_codeset : Pointer(UInt8), from_codeset : Pointer(UInt8), bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_convert_error_quark : UInt32
  fun g_convert_with_fallback(str : Pointer(UInt8), len : Int64, to_codeset : Pointer(UInt8), from_codeset : Pointer(UInt8), fallback : Pointer(UInt8), bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_datalist_foreach(datalist : Pointer(LibGLib::Data), func : LibGLib::DataForeachFunc, user_data : Pointer(Void)) : Void
  fun g_datalist_get_data(datalist : Pointer(LibGLib::Data), key : Pointer(UInt8)) : Pointer(Void)
  fun g_datalist_get_flags(datalist : Pointer(LibGLib::Data)) : UInt32
  fun g_datalist_id_get_data(datalist : Pointer(LibGLib::Data), key_id : UInt32) : Pointer(Void)
  fun g_datalist_set_flags(datalist : Pointer(LibGLib::Data), flags : UInt32) : Void
  fun g_datalist_unset_flags(datalist : Pointer(LibGLib::Data), flags : UInt32) : Void
  fun g_dataset_destroy(dataset_location : Pointer(Void)) : Void
  fun g_dataset_foreach(dataset_location : Pointer(Void), func : LibGLib::DataForeachFunc, user_data : Pointer(Void)) : Void
  fun g_dataset_id_get_data(dataset_location : Pointer(Void), key_id : UInt32) : Pointer(Void)
  fun g_date_get_days_in_month(month : LibGLib::DateMonth, year : UInt16) : UInt8
  fun g_date_get_monday_weeks_in_year(year : UInt16) : UInt8
  fun g_date_get_sunday_weeks_in_year(year : UInt16) : UInt8
  fun g_date_is_leap_year(year : UInt16) : LibC::Int
  fun g_date_strftime(s : Pointer(UInt8), slen : UInt64, format : Pointer(UInt8), date : Pointer(LibGLib::Date)) : UInt64
  fun g_date_valid_day(day : UInt8) : LibC::Int
  fun g_date_valid_dmy(day : UInt8, month : LibGLib::DateMonth, year : UInt16) : LibC::Int
  fun g_date_valid_julian(julian_date : UInt32) : LibC::Int
  fun g_date_valid_month(month : LibGLib::DateMonth) : LibC::Int
  fun g_date_valid_weekday(weekday : LibGLib::DateWeekday) : LibC::Int
  fun g_date_valid_year(year : UInt16) : LibC::Int
  fun g_dcgettext(domain : Pointer(UInt8), msgid : Pointer(UInt8), category : Int32) : Pointer(UInt8)
  fun g_dgettext(domain : Pointer(UInt8), msgid : Pointer(UInt8)) : Pointer(UInt8)
  fun g_dir_make_tmp(tmpl : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_direct_equal(v1 : Pointer(Void), v2 : Pointer(Void)) : LibC::Int
  fun g_direct_hash(v : Pointer(Void)) : UInt32
  fun g_dngettext(domain : Pointer(UInt8), msgid : Pointer(UInt8), msgid_plural : Pointer(UInt8), n : UInt64) : Pointer(UInt8)
  fun g_double_equal(v1 : Pointer(Void), v2 : Pointer(Void)) : LibC::Int
  fun g_double_hash(v : Pointer(Void)) : UInt32
  fun g_dpgettext(domain : Pointer(UInt8), msgctxtid : Pointer(UInt8), msgidoffset : UInt64) : Pointer(UInt8)
  fun g_dpgettext2(domain : Pointer(UInt8), context : Pointer(UInt8), msgid : Pointer(UInt8)) : Pointer(UInt8)
  fun g_environ_getenv(envp : Pointer(Pointer(UInt8)), variable : Pointer(UInt8)) : Pointer(UInt8)
  fun g_environ_setenv(envp : Pointer(Pointer(UInt8)), variable : Pointer(UInt8), value : Pointer(UInt8), overwrite : LibC::Int) : Pointer(Pointer(UInt8))
  fun g_environ_unsetenv(envp : Pointer(Pointer(UInt8)), variable : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_file_error_from_errno(err_no : Int32) : LibGLib::FileError
  fun g_file_error_quark : UInt32
  fun g_file_get_contents(filename : Pointer(UInt8), contents : Pointer(UInt8)*, length : UInt64*, error : LibGLib::Error**) : LibC::Int
  fun g_file_open_tmp(tmpl : Pointer(UInt8), name_used : Pointer(UInt8)*, error : LibGLib::Error**) : Int32
  fun g_file_read_link(filename : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_file_set_contents(filename : Pointer(UInt8), contents : Pointer(UInt8), length : Int64, error : LibGLib::Error**) : LibC::Int
  fun g_file_set_contents_full(filename : Pointer(UInt8), contents : Pointer(UInt8), length : Int64, flags : LibGLib::FileSetContentsFlags, mode : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_file_test(filename : Pointer(UInt8), test : LibGLib::FileTest) : LibC::Int
  fun g_filename_display_basename(filename : Pointer(UInt8)) : Pointer(UInt8)
  fun g_filename_display_name(filename : Pointer(UInt8)) : Pointer(UInt8)
  fun g_filename_from_uri(uri : Pointer(UInt8), hostname : Pointer(UInt8)*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_filename_from_utf8(utf8string : Pointer(UInt8), len : Int64, bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_filename_to_uri(filename : Pointer(UInt8), hostname : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_filename_to_utf8(opsysstring : Pointer(UInt8), len : Int64, bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_find_program_in_path(program : Pointer(UInt8)) : Pointer(UInt8)
  fun g_format_size(size : UInt64) : Pointer(UInt8)
  fun g_format_size_for_display(size : Int64) : Pointer(UInt8)
  fun g_format_size_full(size : UInt64, flags : LibGLib::FormatSizeFlags) : Pointer(UInt8)
  fun g_free(mem : Pointer(Void)) : Void
  fun g_get_application_name : Pointer(UInt8)
  fun g_get_charset(charset : Pointer(UInt8)*) : LibC::Int
  fun g_get_codeset : Pointer(UInt8)
  fun g_get_console_charset(charset : Pointer(UInt8)*) : LibC::Int
  fun g_get_current_dir : Pointer(UInt8)
  fun g_get_current_time(result : Pointer(LibGLib::TimeVal)) : Void
  fun g_get_environ : Pointer(Pointer(UInt8))
  fun g_get_filename_charsets(filename_charsets : Pointer(Pointer(UInt8))*) : LibC::Int
  fun g_get_home_dir : Pointer(UInt8)
  fun g_get_host_name : Pointer(UInt8)
  fun g_get_language_names : Pointer(Pointer(UInt8))
  fun g_get_language_names_with_category(category_name : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_get_locale_variants(locale : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_get_monotonic_time : Int64
  fun g_get_num_processors : UInt32
  fun g_get_os_info(key_name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_get_prgname : Pointer(UInt8)
  fun g_get_real_name : Pointer(UInt8)
  fun g_get_real_time : Int64
  fun g_get_system_config_dirs : Pointer(Pointer(UInt8))
  fun g_get_system_data_dirs : Pointer(Pointer(UInt8))
  fun g_get_tmp_dir : Pointer(UInt8)
  fun g_get_user_cache_dir : Pointer(UInt8)
  fun g_get_user_config_dir : Pointer(UInt8)
  fun g_get_user_data_dir : Pointer(UInt8)
  fun g_get_user_name : Pointer(UInt8)
  fun g_get_user_runtime_dir : Pointer(UInt8)
  fun g_get_user_special_dir(directory : LibGLib::UserDirectory) : Pointer(UInt8)
  fun g_getenv(variable : Pointer(UInt8)) : Pointer(UInt8)
  fun g_hash_table_add(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_contains(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_destroy(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_insert(hash_table : Pointer(Void*), key : Pointer(Void), value : Pointer(Void)) : LibC::Int
  fun g_hash_table_lookup(hash_table : Pointer(Void*), key : Pointer(Void)) : Pointer(Void)
  fun g_hash_table_lookup_extended(hash_table : Pointer(Void*), lookup_key : Pointer(Void), orig_key : Pointer(Void)*, value : Pointer(Void)*) : LibC::Int
  fun g_hash_table_remove(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_remove_all(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_replace(hash_table : Pointer(Void*), key : Pointer(Void), value : Pointer(Void)) : LibC::Int
  fun g_hash_table_size(hash_table : Pointer(Void*)) : UInt32
  fun g_hash_table_steal(hash_table : Pointer(Void*), key : Pointer(Void)) : LibC::Int
  fun g_hash_table_steal_all(hash_table : Pointer(Void*)) : Void
  fun g_hash_table_steal_extended(hash_table : Pointer(Void*), lookup_key : Pointer(Void), stolen_key : Pointer(Void)*, stolen_value : Pointer(Void)*) : LibC::Int
  fun g_hash_table_unref(hash_table : Pointer(Void*)) : Void
  fun g_hook_destroy(hook_list : Pointer(LibGLib::HookList), hook_id : UInt64) : LibC::Int
  fun g_hook_destroy_link(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_free(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_insert_before(hook_list : Pointer(LibGLib::HookList), sibling : Pointer(LibGLib::Hook), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_prepend(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hook_unref(hook_list : Pointer(LibGLib::HookList), hook : Pointer(LibGLib::Hook)) : Void
  fun g_hostname_is_ascii_encoded(hostname : Pointer(UInt8)) : LibC::Int
  fun g_hostname_is_ip_address(hostname : Pointer(UInt8)) : LibC::Int
  fun g_hostname_is_non_ascii(hostname : Pointer(UInt8)) : LibC::Int
  fun g_hostname_to_ascii(hostname : Pointer(UInt8)) : Pointer(UInt8)
  fun g_hostname_to_unicode(hostname : Pointer(UInt8)) : Pointer(UInt8)
  fun g_idle_add_full(priority : Int32, function : LibGLib::SourceFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_idle_remove_by_data(data : Pointer(Void)) : LibC::Int
  fun g_idle_source_new : Pointer(LibGLib::Source)
  fun g_int64_equal(v1 : Pointer(Void), v2 : Pointer(Void)) : LibC::Int
  fun g_int64_hash(v : Pointer(Void)) : UInt32
  fun g_int_equal(v1 : Pointer(Void), v2 : Pointer(Void)) : LibC::Int
  fun g_int_hash(v : Pointer(Void)) : UInt32
  fun g_intern_static_string(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_intern_string(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_io_add_watch_full(channel : Pointer(LibGLib::IOChannel), priority : Int32, condition : LibGLib::IOCondition, func : LibGLib::IOFunc, user_data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_io_channel_error_from_errno(en : Int32) : LibGLib::IOChannelError
  fun g_io_channel_error_quark : UInt32
  fun g_io_create_watch(channel : Pointer(LibGLib::IOChannel), condition : LibGLib::IOCondition) : Pointer(LibGLib::Source)
  fun g_key_file_error_quark : UInt32
  fun g_listenv : Pointer(Pointer(UInt8))
  fun g_locale_from_utf8(utf8string : Pointer(UInt8), len : Int64, bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_locale_to_utf8(opsysstring : Pointer(UInt8), len : Int64, bytes_read : UInt64*, bytes_written : UInt64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_log_default_handler(log_domain : Pointer(UInt8), log_level : LibGLib::LogLevelFlags, message : Pointer(UInt8), unused_data : Pointer(Void)) : Void
  fun g_log_remove_handler(log_domain : Pointer(UInt8), handler_id : UInt32) : Void
  fun g_log_set_always_fatal(fatal_mask : LibGLib::LogLevelFlags) : LibGLib::LogLevelFlags
  fun g_log_set_fatal_mask(log_domain : Pointer(UInt8), fatal_mask : LibGLib::LogLevelFlags) : LibGLib::LogLevelFlags
  fun g_log_set_handler_full(log_domain : Pointer(UInt8), log_levels : LibGLib::LogLevelFlags, log_func : LibGLib::LogFunc, user_data : Pointer(Void), destroy : LibGLib::DestroyNotify) : UInt32
  fun g_log_set_writer_func(func : LibGLib::LogWriterFunc, user_data : Pointer(Void), user_data_free : LibGLib::DestroyNotify) : Void
  fun g_log_structured_array(log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::LogField), n_fields : UInt64) : Void
  fun g_log_variant(log_domain : Pointer(UInt8), log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::Variant)) : Void
  fun g_log_writer_default(log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::LogField), n_fields : UInt64, user_data : Pointer(Void)) : LibGLib::LogWriterOutput
  fun g_log_writer_default_set_use_stderr(use_stderr : LibC::Int) : Void
  fun g_log_writer_default_would_drop(log_level : LibGLib::LogLevelFlags, log_domain : Pointer(UInt8)) : LibC::Int
  fun g_log_writer_format_fields(log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::LogField), n_fields : UInt64, use_color : LibC::Int) : Pointer(UInt8)
  fun g_log_writer_is_journald(output_fd : Int32) : LibC::Int
  fun g_log_writer_journald(log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::LogField), n_fields : UInt64, user_data : Pointer(Void)) : LibGLib::LogWriterOutput
  fun g_log_writer_standard_streams(log_level : LibGLib::LogLevelFlags, fields : Pointer(LibGLib::LogField), n_fields : UInt64, user_data : Pointer(Void)) : LibGLib::LogWriterOutput
  fun g_log_writer_supports_color(output_fd : Int32) : LibC::Int
  fun g_main_context_default : Pointer(LibGLib::MainContext)
  fun g_main_context_get_thread_default : Pointer(LibGLib::MainContext)
  fun g_main_context_ref_thread_default : Pointer(LibGLib::MainContext)
  fun g_main_current_source : Pointer(LibGLib::Source)
  fun g_main_depth : Int32
  fun g_malloc(n_bytes : UInt64) : Pointer(Void)
  fun g_malloc0(n_bytes : UInt64) : Pointer(Void)
  fun g_malloc0_n(n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_malloc_n(n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_markup_error_quark : UInt32
  fun g_markup_escape_text(text : Pointer(UInt8), length : Int64) : Pointer(UInt8)
  fun g_mem_is_system_malloc : LibC::Int
  fun g_mem_profile : Void
  fun g_mem_set_vtable(vtable : Pointer(LibGLib::MemVTable)) : Void
  fun g_memdup(mem : Pointer(Void), byte_size : UInt32) : Pointer(Void)
  fun g_memdup2(mem : Pointer(Void), byte_size : UInt64) : Pointer(Void)
  fun g_mkdir_with_parents(pathname : Pointer(UInt8), mode : Int32) : Int32
  fun g_nullify_pointer(nullify_location : Pointer(Void)) : Void
  fun g_number_parser_error_quark : UInt32
  fun g_on_error_query(prg_name : Pointer(UInt8)) : Void
  fun g_on_error_stack_trace(prg_name : Pointer(UInt8)) : Void
  fun g_once_init_enter(location : Pointer(Void)) : LibC::Int
  fun g_once_init_leave(location : Pointer(Void), result : UInt64) : Void
  fun g_option_error_quark : UInt32
  fun g_parse_debug_string(string : Pointer(UInt8), keys : Pointer(LibGLib::DebugKey), nkeys : UInt32) : UInt32
  fun g_path_get_basename(file_name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_path_get_dirname(file_name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_path_is_absolute(file_name : Pointer(UInt8)) : LibC::Int
  fun g_path_skip_root(file_name : Pointer(UInt8)) : Pointer(UInt8)
  fun g_pattern_match(pspec : Pointer(LibGLib::PatternSpec), string_length : UInt32, string : Pointer(UInt8), string_reversed : Pointer(UInt8)) : LibC::Int
  fun g_pattern_match_simple(pattern : Pointer(UInt8), string : Pointer(UInt8)) : LibC::Int
  fun g_pattern_match_string(pspec : Pointer(LibGLib::PatternSpec), string : Pointer(UInt8)) : LibC::Int
  fun g_pointer_bit_lock(address : Pointer(Void), lock_bit : Int32) : Void
  fun g_pointer_bit_trylock(address : Pointer(Void), lock_bit : Int32) : LibC::Int
  fun g_pointer_bit_unlock(address : Pointer(Void), lock_bit : Int32) : Void
  fun g_poll(fds : Pointer(LibGLib::PollFD), nfds : UInt32, timeout : Int32) : Int32
  fun g_propagate_error(dest : Pointer(LibGLib::Error*)*, src : Pointer(LibGLib::Error*)) : Void
  fun g_quark_from_static_string(string : Pointer(UInt8)) : UInt32
  fun g_quark_from_string(string : Pointer(UInt8)) : UInt32
  fun g_quark_to_string(quark : UInt32) : Pointer(UInt8)
  fun g_quark_try_string(string : Pointer(UInt8)) : UInt32
  fun g_random_double : Float64
  fun g_random_double_range(_begin : Float64, _end : Float64) : Float64
  fun g_random_int : UInt32
  fun g_random_int_range(_begin : Int32, _end : Int32) : Int32
  fun g_random_set_seed(seed : UInt32) : Void
  fun g_rc_box_acquire(mem_block : Pointer(Void)) : Pointer(Void)
  fun g_rc_box_alloc(block_size : UInt64) : Pointer(Void)
  fun g_rc_box_alloc0(block_size : UInt64) : Pointer(Void)
  fun g_rc_box_dup(block_size : UInt64, mem_block : Pointer(Void)) : Pointer(Void)
  fun g_rc_box_get_size(mem_block : Pointer(Void)) : UInt64
  fun g_rc_box_release(mem_block : Pointer(Void)) : Void
  fun g_rc_box_release_full(mem_block : Pointer(Void), clear_func : LibGLib::DestroyNotify) : Void
  fun g_realloc(mem : Pointer(Void), n_bytes : UInt64) : Pointer(Void)
  fun g_realloc_n(mem : Pointer(Void), n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_ref_count_compare(rc : Pointer(Int32), val : Int32) : LibC::Int
  fun g_ref_count_dec(rc : Pointer(Int32)) : LibC::Int
  fun g_ref_count_inc(rc : Pointer(Int32)) : Void
  fun g_ref_count_init(rc : Pointer(Int32)) : Void
  fun g_ref_string_acquire(str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_ref_string_length(str : Pointer(UInt8)) : UInt64
  fun g_ref_string_new(str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_ref_string_new_intern(str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_ref_string_new_len(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_ref_string_release(str : Pointer(UInt8)) : Void
  fun g_regex_check_replacement(replacement : Pointer(UInt8), has_references : LibC::Int*, error : LibGLib::Error**) : LibC::Int
  fun g_regex_error_quark : UInt32
  fun g_regex_escape_nul(string : Pointer(UInt8), length : Int32) : Pointer(UInt8)
  fun g_regex_escape_string(string : Pointer(Pointer(UInt8)), length : Int32) : Pointer(UInt8)
  fun g_regex_match_simple(pattern : Pointer(UInt8), string : Pointer(UInt8), compile_options : LibGLib::RegexCompileFlags, match_options : LibGLib::RegexMatchFlags) : LibC::Int
  fun g_regex_split_simple(pattern : Pointer(UInt8), string : Pointer(UInt8), compile_options : LibGLib::RegexCompileFlags, match_options : LibGLib::RegexMatchFlags) : Pointer(Pointer(UInt8))
  fun g_reload_user_special_dirs_cache : Void
  fun g_rmdir(filename : Pointer(UInt8)) : Int32
  fun g_sequence_get(iter : Pointer(LibGLib::SequenceIter)) : Pointer(Void)
  fun g_sequence_insert_before(iter : Pointer(LibGLib::SequenceIter), data : Pointer(Void)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_move(src : Pointer(LibGLib::SequenceIter), dest : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_move_range(dest : Pointer(LibGLib::SequenceIter), _begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_range_get_midpoint(_begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Pointer(LibGLib::SequenceIter)
  fun g_sequence_remove(iter : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_remove_range(_begin : Pointer(LibGLib::SequenceIter), _end : Pointer(LibGLib::SequenceIter)) : Void
  fun g_sequence_set(iter : Pointer(LibGLib::SequenceIter), data : Pointer(Void)) : Void
  fun g_sequence_swap(a : Pointer(LibGLib::SequenceIter), b : Pointer(LibGLib::SequenceIter)) : Void
  fun g_set_application_name(application_name : Pointer(UInt8)) : Void
  fun g_set_error_literal(err : Pointer(LibGLib::Error*)*, domain : UInt32, code : Int32, message : Pointer(UInt8)) : Void
  fun g_set_prgname(prgname : Pointer(UInt8)) : Void
  fun g_setenv(variable : Pointer(UInt8), value : Pointer(UInt8), overwrite : LibC::Int) : LibC::Int
  fun g_shell_error_quark : UInt32
  fun g_shell_parse_argv(command_line : Pointer(UInt8), argcp : Int32*, argvp : Pointer(Pointer(UInt8))*, error : LibGLib::Error**) : LibC::Int
  fun g_shell_quote(unquoted_string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_shell_unquote(quoted_string : Pointer(UInt8), error : LibGLib::Error**) : Pointer(UInt8)
  fun g_slice_alloc(block_size : UInt64) : Pointer(Void)
  fun g_slice_alloc0(block_size : UInt64) : Pointer(Void)
  fun g_slice_copy(block_size : UInt64, mem_block : Pointer(Void)) : Pointer(Void)
  fun g_slice_free1(block_size : UInt64, mem_block : Pointer(Void)) : Void
  fun g_slice_free_chain_with_offset(block_size : UInt64, mem_chain : Pointer(Void), next_offset : UInt64) : Void
  fun g_slice_get_config(ckey : LibGLib::SliceConfig) : Int64
  fun g_slice_get_config_state(ckey : LibGLib::SliceConfig, address : Int64, n_values : Pointer(UInt32)) : Pointer(Int64)
  fun g_slice_set_config(ckey : LibGLib::SliceConfig, value : Int64) : Void
  fun g_source_remove(tag : UInt32) : LibC::Int
  fun g_source_remove_by_funcs_user_data(funcs : Pointer(LibGLib::SourceFuncs), user_data : Pointer(Void)) : LibC::Int
  fun g_source_remove_by_user_data(user_data : Pointer(Void)) : LibC::Int
  fun g_source_set_name_by_id(tag : UInt32, name : Pointer(UInt8)) : Void
  fun g_spaced_primes_closest(num : UInt32) : UInt32
  fun g_spawn_async(working_directory : Pointer(UInt8), argv : Pointer(Pointer(UInt8)), envp : Pointer(Pointer(UInt8)), flags : LibGLib::SpawnFlags, child_setup : LibGLib::SpawnChildSetupFunc, user_data : Pointer(Void), child_pid : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_async_with_fds(working_directory : Pointer(UInt8), argv : Pointer(Pointer(UInt8)), envp : Pointer(Pointer(UInt8)), flags : LibGLib::SpawnFlags, child_setup : LibGLib::SpawnChildSetupFunc, user_data : Pointer(Void), child_pid : Int32*, stdin_fd : Int32, stdout_fd : Int32, stderr_fd : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_async_with_pipes(working_directory : Pointer(UInt8), argv : Pointer(Pointer(UInt8)), envp : Pointer(Pointer(UInt8)), flags : LibGLib::SpawnFlags, child_setup : LibGLib::SpawnChildSetupFunc, user_data : Pointer(Void), child_pid : Int32*, standard_input : Int32*, standard_output : Int32*, standard_error : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_async_with_pipes_and_fds(working_directory : Pointer(UInt8), argv : Pointer(Pointer(UInt8)), envp : Pointer(Pointer(UInt8)), flags : LibGLib::SpawnFlags, child_setup : LibGLib::SpawnChildSetupFunc, user_data : Pointer(Void), stdin_fd : Int32, stdout_fd : Int32, stderr_fd : Int32, source_fds : Pointer(Int32), target_fds : Pointer(Int32), n_fds : UInt64, child_pid_out : Int32*, stdin_pipe_out : Int32*, stdout_pipe_out : Int32*, stderr_pipe_out : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_check_exit_status(exit_status : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_close_pid(pid : Int32) : Void
  fun g_spawn_command_line_async(command_line : Pointer(UInt8), error : LibGLib::Error**) : LibC::Int
  fun g_spawn_command_line_sync(command_line : Pointer(UInt8), standard_output : Pointer(UInt8)*, standard_error : Pointer(UInt8)*, exit_status : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_spawn_error_quark : UInt32
  fun g_spawn_exit_error_quark : UInt32
  fun g_spawn_sync(working_directory : Pointer(UInt8), argv : Pointer(Pointer(UInt8)), envp : Pointer(Pointer(UInt8)), flags : LibGLib::SpawnFlags, child_setup : LibGLib::SpawnChildSetupFunc, user_data : Pointer(Void), standard_output : Pointer(UInt8)*, standard_error : Pointer(UInt8)*, exit_status : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_stpcpy(dest : Pointer(UInt8), src : Pointer(UInt8)) : Pointer(UInt8)
  fun g_str_equal(v1 : Pointer(Void), v2 : Pointer(Void)) : LibC::Int
  fun g_str_has_prefix(str : Pointer(UInt8), prefix : Pointer(UInt8)) : LibC::Int
  fun g_str_has_suffix(str : Pointer(UInt8), suffix : Pointer(UInt8)) : LibC::Int
  fun g_str_hash(v : Pointer(Void)) : UInt32
  fun g_str_is_ascii(str : Pointer(UInt8)) : LibC::Int
  fun g_str_match_string(search_term : Pointer(UInt8), potential_hit : Pointer(UInt8), accept_alternates : LibC::Int) : LibC::Int
  fun g_str_to_ascii(str : Pointer(UInt8), from_locale : Pointer(UInt8)) : Pointer(UInt8)
  fun g_str_tokenize_and_fold(string : Pointer(UInt8), translit_locale : Pointer(UInt8), ascii_alternates : Pointer(Pointer(UInt8))*) : Pointer(Pointer(UInt8))
  fun g_strcanon(string : Pointer(UInt8), valid_chars : Pointer(UInt8), substitutor : Int8) : Pointer(UInt8)
  fun g_strcasecmp(s1 : Pointer(UInt8), s2 : Pointer(UInt8)) : Int32
  fun g_strchomp(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strchug(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strcmp0(str1 : Pointer(UInt8), str2 : Pointer(UInt8)) : Int32
  fun g_strcompress(source : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strdelimit(string : Pointer(UInt8), delimiters : Pointer(UInt8), new_delimiter : Int8) : Pointer(UInt8)
  fun g_strdown(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strdup(str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strerror(errnum : Int32) : Pointer(UInt8)
  fun g_strescape(source : Pointer(UInt8), exceptions : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strfreev(str_array : Pointer(UInt8)) : Void
  fun g_string_new(init : Pointer(UInt8)) : Pointer(LibGLib::String)
  fun g_string_new_len(init : Pointer(UInt8), len : Int64) : Pointer(LibGLib::String)
  fun g_string_sized_new(dfl_size : UInt64) : Pointer(LibGLib::String)
  fun g_strip_context(msgid : Pointer(UInt8), msgval : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strjoinv(separator : Pointer(UInt8), str_array : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strlcat(dest : Pointer(UInt8), src : Pointer(UInt8), dest_size : UInt64) : UInt64
  fun g_strlcpy(dest : Pointer(UInt8), src : Pointer(UInt8), dest_size : UInt64) : UInt64
  fun g_strncasecmp(s1 : Pointer(UInt8), s2 : Pointer(UInt8), n : UInt32) : Int32
  fun g_strndup(str : Pointer(UInt8), n : UInt64) : Pointer(UInt8)
  fun g_strnfill(length : UInt64, fill_char : Int8) : Pointer(UInt8)
  fun g_strreverse(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strrstr(haystack : Pointer(UInt8), needle : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strrstr_len(haystack : Pointer(UInt8), haystack_len : Int64, needle : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strsignal(signum : Int32) : Pointer(UInt8)
  fun g_strstr_len(haystack : Pointer(UInt8), haystack_len : Int64, needle : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strtod(nptr : Pointer(UInt8), endptr : Pointer(UInt8)*) : Float64
  fun g_strup(string : Pointer(UInt8)) : Pointer(UInt8)
  fun g_strv_contains(strv : Pointer(UInt8), str : Pointer(UInt8)) : LibC::Int
  fun g_strv_equal(strv1 : Pointer(UInt8), strv2 : Pointer(UInt8)) : LibC::Int
  fun g_strv_get_type : UInt64
  fun g_strv_length(str_array : Pointer(UInt8)) : UInt32
  fun g_test_add_data_func(testpath : Pointer(UInt8), test_data : Pointer(Void), test_func : LibGLib::TestDataFunc) : Void
  fun g_test_add_data_func_full(testpath : Pointer(UInt8), test_data : Pointer(Void), test_func : LibGLib::TestDataFunc, data_free_func : LibGLib::DestroyNotify) : Void
  fun g_test_add_func(testpath : Pointer(UInt8), test_func : LibGLib::TestFunc) : Void
  fun g_test_assert_expected_messages_internal(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8)) : Void
  fun g_test_bug(bug_uri_snippet : Pointer(UInt8)) : Void
  fun g_test_bug_base(uri_pattern : Pointer(UInt8)) : Void
  fun g_test_expect_message(log_domain : Pointer(UInt8), log_level : LibGLib::LogLevelFlags, pattern : Pointer(UInt8)) : Void
  fun g_test_fail : Void
  fun g_test_failed : LibC::Int
  fun g_test_get_dir(file_type : LibGLib::TestFileType) : Pointer(UInt8)
  fun g_test_get_path : Pointer(UInt8)
  fun g_test_incomplete(msg : Pointer(UInt8)) : Void
  fun g_test_log_type_name(log_type : LibGLib::TestLogType) : Pointer(UInt8)
  fun g_test_queue_destroy(destroy_func : LibGLib::DestroyNotify, destroy_data : Pointer(Void)) : Void
  fun g_test_queue_free(gfree_pointer : Pointer(Void)) : Void
  fun g_test_rand_double : Float64
  fun g_test_rand_double_range(range_start : Float64, range_end : Float64) : Float64
  fun g_test_rand_int : Int32
  fun g_test_rand_int_range(_begin : Int32, _end : Int32) : Int32
  fun g_test_run : Int32
  fun g_test_run_suite(suite : Pointer(LibGLib::TestSuite)) : Int32
  fun g_test_set_nonfatal_assertions : Void
  fun g_test_skip(msg : Pointer(UInt8)) : Void
  fun g_test_subprocess : LibC::Int
  fun g_test_summary(summary : Pointer(UInt8)) : Void
  fun g_test_timer_elapsed : Float64
  fun g_test_timer_last : Float64
  fun g_test_timer_start : Void
  fun g_test_trap_assertions(domain : Pointer(UInt8), file : Pointer(UInt8), line : Int32, func : Pointer(UInt8), assertion_flags : UInt64, pattern : Pointer(UInt8)) : Void
  fun g_test_trap_fork(usec_timeout : UInt64, test_trap_flags : LibGLib::TestTrapFlags) : LibC::Int
  fun g_test_trap_has_passed : LibC::Int
  fun g_test_trap_reached_timeout : LibC::Int
  fun g_test_trap_subprocess(test_path : Pointer(UInt8), usec_timeout : UInt64, test_flags : LibGLib::TestSubprocessFlags) : Void
  fun g_thread_error_quark : UInt32
  fun g_thread_exit(retval : Pointer(Void)) : Void
  fun g_thread_pool_get_max_idle_time : UInt32
  fun g_thread_pool_get_max_unused_threads : Int32
  fun g_thread_pool_get_num_unused_threads : UInt32
  fun g_thread_pool_set_max_idle_time(interval : UInt32) : Void
  fun g_thread_pool_set_max_unused_threads(max_threads : Int32) : Void
  fun g_thread_pool_stop_unused_threads : Void
  fun g_thread_self : Pointer(LibGLib::Thread)
  fun g_thread_yield : Void
  fun g_time_val_from_iso8601(iso_date : Pointer(UInt8), time_ : LibGLib::TimeVal*) : LibC::Int
  fun g_timeout_add_full(priority : Int32, interval : UInt32, function : LibGLib::SourceFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_timeout_add_seconds_full(priority : Int32, interval : UInt32, function : LibGLib::SourceFunc, data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_timeout_source_new(interval : UInt32) : Pointer(LibGLib::Source)
  fun g_timeout_source_new_seconds(interval : UInt32) : Pointer(LibGLib::Source)
  fun g_trash_stack_height(stack_p : Pointer(LibGLib::TrashStack)) : UInt32
  fun g_trash_stack_peek(stack_p : Pointer(LibGLib::TrashStack)) : Pointer(Void)
  fun g_trash_stack_pop(stack_p : Pointer(LibGLib::TrashStack)) : Pointer(Void)
  fun g_trash_stack_push(stack_p : Pointer(LibGLib::TrashStack), data_p : Pointer(Void)) : Void
  fun g_try_malloc(n_bytes : UInt64) : Pointer(Void)
  fun g_try_malloc0(n_bytes : UInt64) : Pointer(Void)
  fun g_try_malloc0_n(n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_try_malloc_n(n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_try_realloc(mem : Pointer(Void), n_bytes : UInt64) : Pointer(Void)
  fun g_try_realloc_n(mem : Pointer(Void), n_blocks : UInt64, n_block_bytes : UInt64) : Pointer(Void)
  fun g_ucs4_to_utf16(str : Pointer(UInt8), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt16)
  fun g_ucs4_to_utf8(str : Pointer(UInt8), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_unichar_break_type(c : UInt8) : LibGLib::UnicodeBreakType
  fun g_unichar_combining_class(uc : UInt8) : Int32
  fun g_unichar_compose(a : UInt8, b : UInt8, ch : UInt8*) : LibC::Int
  fun g_unichar_decompose(ch : UInt8, a : UInt8*, b : UInt8*) : LibC::Int
  fun g_unichar_digit_value(c : UInt8) : Int32
  fun g_unichar_fully_decompose(ch : UInt8, compat : LibC::Int, result : UInt8*, result_len : UInt64) : UInt64
  fun g_unichar_get_mirror_char(ch : UInt8, mirrored_ch : Pointer(UInt8)) : LibC::Int
  fun g_unichar_get_script(ch : UInt8) : LibGLib::UnicodeScript
  fun g_unichar_isalnum(c : UInt8) : LibC::Int
  fun g_unichar_isalpha(c : UInt8) : LibC::Int
  fun g_unichar_iscntrl(c : UInt8) : LibC::Int
  fun g_unichar_isdefined(c : UInt8) : LibC::Int
  fun g_unichar_isdigit(c : UInt8) : LibC::Int
  fun g_unichar_isgraph(c : UInt8) : LibC::Int
  fun g_unichar_islower(c : UInt8) : LibC::Int
  fun g_unichar_ismark(c : UInt8) : LibC::Int
  fun g_unichar_isprint(c : UInt8) : LibC::Int
  fun g_unichar_ispunct(c : UInt8) : LibC::Int
  fun g_unichar_isspace(c : UInt8) : LibC::Int
  fun g_unichar_istitle(c : UInt8) : LibC::Int
  fun g_unichar_isupper(c : UInt8) : LibC::Int
  fun g_unichar_iswide(c : UInt8) : LibC::Int
  fun g_unichar_iswide_cjk(c : UInt8) : LibC::Int
  fun g_unichar_isxdigit(c : UInt8) : LibC::Int
  fun g_unichar_iszerowidth(c : UInt8) : LibC::Int
  fun g_unichar_to_utf8(c : UInt8, outbuf : Pointer(UInt8)*) : Int32
  fun g_unichar_tolower(c : UInt8) : UInt8
  fun g_unichar_totitle(c : UInt8) : UInt8
  fun g_unichar_toupper(c : UInt8) : UInt8
  fun g_unichar_type(c : UInt8) : LibGLib::UnicodeType
  fun g_unichar_validate(ch : UInt8) : LibC::Int
  fun g_unichar_xdigit_value(c : UInt8) : Int32
  fun g_unicode_canonical_decomposition(ch : UInt8, result_len : Pointer(UInt64)) : Pointer(UInt8)
  fun g_unicode_canonical_ordering(string : Pointer(UInt8), len : UInt64) : Void
  fun g_unicode_script_from_iso15924(iso15924 : UInt32) : LibGLib::UnicodeScript
  fun g_unicode_script_to_iso15924(script : LibGLib::UnicodeScript) : UInt32
  fun g_unix_error_quark : UInt32
  fun g_unix_fd_add_full(priority : Int32, fd : Int32, condition : LibGLib::IOCondition, function : LibGLib::UnixFDSourceFunc, user_data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_unix_fd_source_new(fd : Int32, condition : LibGLib::IOCondition) : Pointer(LibGLib::Source)
  fun g_unix_get_passwd_entry(user_name : Pointer(UInt8), error : LibGLib::Error**) : Pointer(Void)
  fun g_unix_open_pipe(fds : Pointer(Int32), flags : Int32, error : LibGLib::Error**) : LibC::Int
  fun g_unix_set_fd_nonblocking(fd : Int32, nonblock : LibC::Int, error : LibGLib::Error**) : LibC::Int
  fun g_unix_signal_add_full(priority : Int32, signum : Int32, handler : LibGLib::SourceFunc, user_data : Pointer(Void), notify : LibGLib::DestroyNotify) : UInt32
  fun g_unix_signal_source_new(signum : Int32) : Pointer(LibGLib::Source)
  fun g_unlink(filename : Pointer(UInt8)) : Int32
  fun g_unsetenv(variable : Pointer(UInt8)) : Void
  fun g_uri_build(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), userinfo : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(LibGLib::Uri)
  fun g_uri_build_with_user(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), user : Pointer(UInt8), password : Pointer(UInt8), auth_params : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(LibGLib::Uri)
  fun g_uri_error_quark : UInt32
  fun g_uri_escape_bytes(unescaped : Pointer(UInt8), length : UInt64, reserved_chars_allowed : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_escape_string(unescaped : Pointer(UInt8), reserved_chars_allowed : Pointer(UInt8), allow_utf8 : LibC::Int) : Pointer(UInt8)
  fun g_uri_is_valid(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : LibC::Int
  fun g_uri_join(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), userinfo : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_join_with_user(flags : LibGLib::UriFlags, scheme : Pointer(UInt8), user : Pointer(UInt8), password : Pointer(UInt8), auth_params : Pointer(UInt8), host : Pointer(UInt8), port : Int32, path : Pointer(UInt8), query : Pointer(UInt8), fragment : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_list_extract_uris(uri_list : Pointer(UInt8)) : Pointer(Pointer(UInt8))
  fun g_uri_parse(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : Pointer(LibGLib::Uri)
  fun g_uri_parse_params(params : Pointer(UInt8), length : Int64, separators : Pointer(UInt8), flags : LibGLib::UriParamsFlags, error : LibGLib::Error**) : Pointer(Void*)
  fun g_uri_parse_scheme(uri : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_peek_scheme(uri : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_resolve_relative(base_uri_string : Pointer(UInt8), uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_uri_split(uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, userinfo : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, path : Pointer(UInt8)*, query : Pointer(UInt8)*, fragment : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_split_network(uri_string : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_split_with_user(uri_ref : Pointer(UInt8), flags : LibGLib::UriFlags, scheme : Pointer(UInt8)*, user : Pointer(UInt8)*, password : Pointer(UInt8)*, auth_params : Pointer(UInt8)*, host : Pointer(UInt8)*, port : Int32*, path : Pointer(UInt8)*, query : Pointer(UInt8)*, fragment : Pointer(UInt8)*, error : LibGLib::Error**) : LibC::Int
  fun g_uri_unescape_bytes(escaped_string : Pointer(UInt8), length : Int64, illegal_characters : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::Bytes)
  fun g_uri_unescape_segment(escaped_string : Pointer(UInt8), escaped_string_end : Pointer(UInt8), illegal_characters : Pointer(UInt8)) : Pointer(UInt8)
  fun g_uri_unescape_string(escaped_string : Pointer(UInt8), illegal_characters : Pointer(UInt8)) : Pointer(UInt8)
  fun g_usleep(microseconds : UInt64) : Void
  fun g_utf16_to_ucs4(str : Pointer(UInt16), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_utf16_to_utf8(str : Pointer(UInt16), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_utf8_casefold(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_collate(str1 : Pointer(UInt8), str2 : Pointer(UInt8)) : Int32
  fun g_utf8_collate_key(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_collate_key_for_filename(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_find_next_char(p : Pointer(UInt8), _end : Pointer(UInt8)) : Pointer(UInt8)
  fun g_utf8_find_prev_char(str : Pointer(UInt8), p : Pointer(UInt8)) : Pointer(UInt8)
  fun g_utf8_get_char(p : Pointer(UInt8)) : UInt8
  fun g_utf8_get_char_validated(p : Pointer(UInt8), max_len : Int64) : UInt8
  fun g_utf8_make_valid(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_normalize(str : Pointer(UInt8), len : Int64, mode : LibGLib::NormalizeMode) : Pointer(UInt8)
  fun g_utf8_offset_to_pointer(str : Pointer(UInt8), offset : Int64) : Pointer(UInt8)
  fun g_utf8_pointer_to_offset(str : Pointer(UInt8), pos : Pointer(UInt8)) : Int64
  fun g_utf8_prev_char(p : Pointer(UInt8)) : Pointer(UInt8)
  fun g_utf8_strchr(p : Pointer(UInt8), len : Int64, c : UInt8) : Pointer(UInt8)
  fun g_utf8_strdown(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_strlen(p : Pointer(UInt8), max : Int64) : Int64
  fun g_utf8_strncpy(dest : Pointer(UInt8), src : Pointer(UInt8), n : UInt64) : Pointer(UInt8)
  fun g_utf8_strrchr(p : Pointer(UInt8), len : Int64, c : UInt8) : Pointer(UInt8)
  fun g_utf8_strreverse(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_strup(str : Pointer(UInt8), len : Int64) : Pointer(UInt8)
  fun g_utf8_substring(str : Pointer(UInt8), start_pos : Int64, end_pos : Int64) : Pointer(UInt8)
  fun g_utf8_to_ucs4(str : Pointer(UInt8), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt8)
  fun g_utf8_to_ucs4_fast(str : Pointer(UInt8), len : Int64, items_written : Int64*) : Pointer(UInt8)
  fun g_utf8_to_utf16(str : Pointer(UInt8), len : Int64, items_read : Int64*, items_written : Int64*, error : LibGLib::Error**) : Pointer(UInt16)
  fun g_utf8_validate(str : Pointer(UInt8), max_len : Int64, _end : Pointer(UInt8)*) : LibC::Int
  fun g_utf8_validate_len(str : Pointer(UInt8), max_len : UInt64, _end : Pointer(UInt8)*) : LibC::Int
  fun g_uuid_string_is_valid(str : Pointer(UInt8)) : LibC::Int
  fun g_uuid_string_random : Pointer(UInt8)
  fun g_variant_get_gtype : UInt64
  fun g_variant_is_object_path(string : Pointer(UInt8)) : LibC::Int
  fun g_variant_is_signature(string : Pointer(UInt8)) : LibC::Int
  fun g_variant_parse(type : Pointer(LibGLib::VariantType), text : Pointer(UInt8), limit : Pointer(UInt8), endptr : Pointer(UInt8), error : LibGLib::Error**) : Pointer(LibGLib::Variant)
  fun g_variant_parse_error_print_context(error : Pointer(LibGLib::Error*), source_str : Pointer(UInt8)) : Pointer(UInt8)
  fun g_variant_parse_error_quark : UInt32
  fun g_variant_parser_get_error_quark : UInt32
  fun g_variant_type_checked_(arg0 : Pointer(UInt8)) : Pointer(LibGLib::VariantType)
  fun g_variant_type_string_get_depth_(type_string : Pointer(UInt8)) : UInt64
  fun g_variant_type_string_is_valid(type_string : Pointer(UInt8)) : LibC::Int
  fun g_variant_type_string_scan(string : Pointer(UInt8), limit : Pointer(UInt8), endptr : Pointer(UInt8)*) : LibC::Int

  ###########################################
  ##    Callbacks
  ###########################################
  alias ChildWatchFunc = Int32, Int32, Pointer(Void) -> Void
  alias ClearHandleFunc = UInt32 -> Void
  alias CompareDataFunc = Pointer(Void), Pointer(Void), Pointer(Void) -> Int32
  alias CompareFunc = Pointer(Void), Pointer(Void) -> Int32
  alias CopyFunc = Pointer(Void), Pointer(Void) -> Pointer(Void)
  alias DataForeachFunc = UInt32, Pointer(Void), Pointer(Void) -> Void
  alias DestroyNotify = Pointer(Void) -> Void
  alias DuplicateFunc = Pointer(Void), Pointer(Void) -> Pointer(Void)
  alias EqualFunc = Pointer(Void), Pointer(Void) -> LibC::Int
  alias ErrorClearFunc = Pointer(LibGLib::Error*) -> Void
  alias ErrorCopyFunc = Pointer(LibGLib::Error*), Pointer(LibGLib::Error*) -> Void
  alias ErrorInitFunc = Pointer(LibGLib::Error*) -> Void
  alias FreeFunc = Pointer(Void) -> Void
  alias Func = Pointer(Void), Pointer(Void) -> Void
  alias HFunc = Pointer(Void), Pointer(Void), Pointer(Void) -> Void
  alias HRFunc = Pointer(Void), Pointer(Void), Pointer(Void) -> LibC::Int
  alias HashFunc = Pointer(Void) -> UInt32
  alias HookCheckFunc = Pointer(Void) -> LibC::Int
  alias HookCheckMarshaller = Pointer(LibGLib::Hook), Pointer(Void) -> LibC::Int
  alias HookCompareFunc = Pointer(LibGLib::Hook), Pointer(LibGLib::Hook) -> Int32
  alias HookFinalizeFunc = Pointer(LibGLib::HookList), Pointer(LibGLib::Hook) -> Void
  alias HookFindFunc = Pointer(LibGLib::Hook), Pointer(Void) -> LibC::Int
  alias HookFunc = Pointer(Void) -> Void
  alias HookMarshaller = Pointer(LibGLib::Hook), Pointer(Void) -> Void
  alias IOFunc = Pointer(LibGLib::IOChannel), LibGLib::IOCondition, Pointer(Void) -> LibC::Int
  alias LogFunc = Pointer(UInt8), LibGLib::LogLevelFlags, Pointer(UInt8), Pointer(Void) -> Void
  alias LogWriterFunc = LibGLib::LogLevelFlags, Pointer(LibGLib::LogField), UInt64, Pointer(Void) -> LibGLib::LogWriterOutput
  alias NodeForeachFunc = Pointer(LibGLib::Node), Pointer(Void) -> Void
  alias NodeTraverseFunc = Pointer(LibGLib::Node), Pointer(Void) -> LibC::Int
  alias OptionArgFunc = Pointer(UInt8), Pointer(UInt8), Pointer(Void), LibGLib::Error* -> LibC::Int
  alias OptionErrorFunc = Pointer(LibGLib::OptionContext), Pointer(LibGLib::OptionGroup), Pointer(Void), LibGLib::Error* -> Void
  alias OptionParseFunc = Pointer(LibGLib::OptionContext), Pointer(LibGLib::OptionGroup), Pointer(Void), LibGLib::Error* -> LibC::Int
  alias PollFunc = Pointer(LibGLib::PollFD), UInt32, Int32 -> Int32
  alias PrintFunc = Pointer(UInt8) -> Void
  alias RegexEvalCallback = Pointer(LibGLib::MatchInfo), Pointer(LibGLib::String), Pointer(Void) -> LibC::Int
  alias ScannerMsgFunc = Pointer(LibGLib::Scanner), Pointer(UInt8), LibC::Int -> Void
  alias SequenceIterCompareFunc = Pointer(LibGLib::SequenceIter), Pointer(LibGLib::SequenceIter), Pointer(Void) -> Int32
  alias SourceDisposeFunc = Pointer(LibGLib::Source) -> Void
  alias SourceDummyMarshal = -> Void
  alias SourceFunc = Pointer(Void) -> LibC::Int
  alias SpawnChildSetupFunc = Pointer(Void) -> Void
  alias TestDataFunc = Pointer(Void) -> Void
  alias TestFixtureFunc = Pointer(Void), Pointer(Void) -> Void
  alias TestFunc = -> Void
  alias TestLogFatalFunc = Pointer(UInt8), LibGLib::LogLevelFlags, Pointer(UInt8), Pointer(Void) -> LibC::Int
  alias ThreadFunc = Pointer(Void) -> Pointer(Void)
  alias TranslateFunc = Pointer(UInt8), Pointer(Void) -> Pointer(UInt8)
  alias TraverseFunc = Pointer(Void), Pointer(Void), Pointer(Void) -> LibC::Int
  alias TraverseNodeFunc = Pointer(LibGLib::TreeNode), Pointer(Void) -> LibC::Int
  alias UnixFDSourceFunc = Int32, LibGLib::IOCondition, Pointer(Void) -> LibC::Int
  alias VoidFunc = -> Void
end
