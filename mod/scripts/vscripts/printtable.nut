untyped

globalize_all_functions



string function printablebetterweee( tbl, indent = 4, maxDepth = 999 )
{
	print( TableIndent( indent ) )
	return dqwdwqdwqdq( tbl, indent, 0, maxDepth )
}


string function dqwdwqdwqdq( obj, indent, depth, maxDepth )
{
	string current = ""

	if ( IsTable( obj ) )
	{
		if ( depth >= maxDepth )
		{
			current += "{...}"
			return current
		}

		current += "{\n"
		local first = true
		foreach ( k, v in obj )
		{
			if ( !first )
				current += ",\n"
			first = false

			current += TableIndent( indent + 2 ) + "\"" + k + "\": "
			current += dqwdwqdwqdq( v, indent + 2, depth + 1, maxDepth )
		}
		current += "\n" + TableIndent( indent ) + "}"
	}
	else if ( IsArray( obj ) )
	{
		if ( depth >= maxDepth )
		{
			current += "[...]"
			return current
		}

		current += "[\n"
		local first = true
		foreach ( v in obj )
		{
			if ( !first )
				current += ",\n"
			first = false

			current += TableIndent( indent + 2 )
			current += dqwdwqdwqdq( v, indent + 2, depth + 1, maxDepth )
		}
		current += "\n" + TableIndent( indent ) + "]"
	}
	else if ( typeof( obj ) == "string" )
	{
		current += "\"" + obj + "\""
	}
	else if ( obj != null )
	{
		current += "" + obj
	}
	else
	{
		current += "null"
	}
	return current
}