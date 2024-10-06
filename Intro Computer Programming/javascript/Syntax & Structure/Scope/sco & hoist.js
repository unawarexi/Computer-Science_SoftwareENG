/** SCOPE
 * refers to where a variable is declared and from where it can be accessed
 *  local scope and global 
 *     1 local inside any data struct can't be used anywhere 
 *       except inside it's specific code block
 *     2 outside any data struct and can be used anywhere
 * 
 *  when using local you can redeclare with same var_name but it must be in different code block
 * 
 * NOTE : it is important to use local scope more than global
 *        var is only locally scoped in a FUNCTION avoid using var;
 * 
 */


/*============================================================== HOISTING*
 * meaning var or functions can be called at the top before writing the codes for it
 * it's a defualt behaviour of javascript
 * it doesn't affect assignmet / init
 *  it's for declaration 
 */