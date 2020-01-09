/*
    Disable anonymous access
*/
security.setAnonymousAccess(false)
/*
    Set the password of the admin to 123
    I tried to use env variables but nexus groovy intepreter container doesn't allow java.lang.System to be imported
*/
security.getSecuritySystem().changePassword("admin", "123")