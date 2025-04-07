/** 
 * The 'os' module:
 * The 'os' module in Node.js provides methods to interact with the operating system and retrieve useful system-related information.
 * This includes details about the platform, memory, CPUs, network interfaces, uptime, and more.

 * - os.arch(): Retrieves the CPU architecture of the operating system (e.g., 'x64' for 64-bit).
 * - os.platform(): Returns the operating system platform (e.g., 'win32', 'linux', 'darwin').
 * - os.hostname(): Returns the name of the machine (hostname).
 * - os.totalmem() and os.freemem(): Provide the total and free memory in bytes, respectively.
 * - os.uptime(): Returns the system uptime (how long the OS has been running since last reboot).
 * - os.userInfo(): Provides details about the current logged-in user.
 * - os.cpus(): Returns an array of objects representing each CPU/core with details like speed and model.
 * - os.networkInterfaces(): Retrieves network interfaces (IP addresses, etc.).
 * - os.release(): Returns the version of the operating system.
 * - os.tmpdir(): Returns the path to the system's temporary files directory.
 * - os.endianness(): Returns the CPU byte order (endianness).
 * - os.homedir(): Retrieves the path to the current user's home directory.
 * - os.loadavg(): Returns system load averages (Unix systems only).
 * - os.type(): Returns the name of the operating system.
 */

const os = require('os');

//////////////////////////////////////////////////////////////

/** 
 * Example 1: Get System Architecture
 * `os.arch()` returns the operating system CPU architecture (e.g., 'x64' for 64-bit architecture).
 */
const architecture = os.arch();
console.log('System architecture:', architecture); // Outputs 'x64' or another architecture

//////////////////////////////////////////////////////////////

/** 
 * Example 2: Get Platform
 * `os.platform()` returns the platform of the operating system (e.g., 'win32', 'linux', 'darwin').
 */
const platform = os.platform();
console.log('Operating system platform:', platform); // Outputs 'win32', 'linux', or 'darwin'

//////////////////////////////////////////////////////////////

/** 
 * Example 3: Get Hostname
 * `os.hostname()` returns the hostname of the operating system (the name of the device).
 */
const hostname = os.hostname();
console.log('Hostname:', hostname); // Outputs the name of the host machine

//////////////////////////////////////////////////////////////

/** 
 * Example 4: Get Total and Free Memory
 * `os.totalmem()` returns the total amount of system memory in bytes, 
 * and `os.freemem()` returns the amount of free memory available.
 */
const totalMemory = os.totalmem();
const freeMemory = os.freemem();
console.log('Total memory:', totalMemory / (1024 ** 3), 'GB'); // Converts bytes to GB
console.log('Free memory:', freeMemory / (1024 ** 3), 'GB'); // Converts bytes to GB

//////////////////////////////////////////////////////////////

/** 
 * Example 5: Get System Uptime
 * `os.uptime()` returns the system uptime in seconds (how long the system has been running since the last boot).
 */
const uptime = os.uptime();
console.log('System uptime:', uptime / 3600, 'hours'); // Converts seconds to hours

//////////////////////////////////////////////////////////////

/** 
 * Example 6: Get User Information
 * `os.userInfo()` returns an object containing information about the current user (username, home directory, etc.).
 */
const userInfo = os.userInfo();
console.log('User info:', userInfo); // Outputs user info object

//////////////////////////////////////////////////////////////

/** 
 * Example 7: Get CPU Information
 * `os.cpus()` returns an array of objects containing information about each CPU/core installed (e.g., model, speed, times).
 */
const cpus = os.cpus();
console.log('Number of CPUs:', cpus.length);
console.log('CPU details:', cpus); // Outputs details for each CPU core

//////////////////////////////////////////////////////////////

/** 
 * Example 8: Get Network Interfaces
 * `os.networkInterfaces()` returns an object containing network interfaces with their associated IP addresses and other details.
 */
const networkInterfaces = os.networkInterfaces();
console.log('Network interfaces:', networkInterfaces); // Outputs network interfaces and their IP addresses

//////////////////////////////////////////////////////////////

/** 
 * Example 9: Get Operating System Release
 * `os.release()` returns the operating system version or release number.
 */
const osRelease = os.release();
console.log('Operating system release:', osRelease); // Outputs OS release, e.g., '10.0.19041' for Windows

//////////////////////////////////////////////////////////////

/** 
 * Example 10: Get Temporary Directory
 * `os.tmpdir()` returns the default directory for storing temporary files on the system.
 */
const tempDirectory = os.tmpdir();
console.log('Temporary directory:', tempDirectory); // Outputs the path to the system's temp directory

//////////////////////////////////////////////////////////////

/** 
 * Example 11: Get Endianness
 * `os.endianness()` returns the CPU endianness ('BE' for big-endian or 'LE' for little-endian).
 * Endianness defines the byte order in which multibyte data is stored.
 */
const endianness = os.endianness();
console.log('CPU endianness:', endianness); // Outputs 'LE' or 'BE'

//////////////////////////////////////////////////////////////

/** 
 * Example 12: Get Home Directory
 * `os.homedir()` returns the path to the current user's home directory.
 */
const homeDirectory = os.homedir();
console.log('Home directory:', homeDirectory); // Outputs the home directory path

//////////////////////////////////////////////////////////////

/** 
 * Example 13: Get Load Average (Unix-based systems only)
 * `os.loadavg()` returns an array containing the load averages for the last 1, 5, and 15 minutes. 
 * It provides a measure of system activity on Unix-based systems (not available on Windows).
 */
const loadAverage = os.loadavg();
console.log('Load average:', loadAverage); // Outputs the system's load average over 1, 5, and 15 minutes

//////////////////////////////////////////////////////////////

/** 
 * Example 14: Get System Type
 * `os.type()` returns the name of the operating system (e.g., 'Windows_NT', 'Linux', 'Darwin').
 */
const osType = os.type();
console.log('Operating system type:', osType); // Outputs 'Windows_NT', 'Linux', or 'Darwin'
