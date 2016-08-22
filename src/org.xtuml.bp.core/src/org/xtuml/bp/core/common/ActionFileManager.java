// ========================================================================
//
//File: $RCSfile: ActionFileManager.java,v $
//
//========================================================================
//
package org.xtuml.bp.core.common;

import java.util.HashMap;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.xtuml.bp.core.Ooaofooa;

public class ActionFileManager {
	
	private static final String[] DIALECTS = { "oal", "masl" };
	
	private HashMap<String,IFile> fileMap;
	
	public ActionFileManager( String componentFileName ) {
		fileMap = new HashMap<String,IFile>();
		for ( int i = 0; i < DIALECTS.length; i++ ) {
			IPath actionFilePath = getPathFromComponent(componentFileName, DIALECTS[i]);
			fileMap.put(DIALECTS[i], ResourcesPlugin.getWorkspace().getRoot().getFile(actionFilePath));
		}
	}
	
	public ActionFileManager( IPath componentPath ) {
		fileMap = new HashMap<String,IFile>();
		for ( int i = 0; i < DIALECTS.length; i++ ) {
			IPath actionFilePath = getPathFromComponent(componentPath, DIALECTS[i]);
			fileMap.put(DIALECTS[i], ResourcesPlugin.getWorkspace().getRoot().getFile(actionFilePath));
		}
	}
	
	public void updateFiles( IPath newPath ) {
		fileMap = new HashMap<String,IFile>();
		for ( int i = 0; i < DIALECTS.length; i++ ) {
			IPath actionFilePath = getPathFromComponent(newPath, DIALECTS[i]);
			fileMap.put(DIALECTS[i], ResourcesPlugin.getWorkspace().getRoot().getFile(actionFilePath));
		}
	}
	
	// get the dialect for this action file manager. This will check to see if actions exist
	// for one dialect, if not it will go to the default dialect
	public String getDialect() {
		return "oal";
	}
	
	// get the file for this action file manager. This will check to see if actions exist
	// for one dialect, if not it will go to the default dialect
	public IFile getFile() {
		return fileMap.get(getDialect());
	}
	
	public static String getDefaultDialect() {
		return "oal";
	}
	
	// get the action file path from the component file path
	public IPath getPathFromComponent( IPath path ) {
		return getPathFromComponent( path, getDialect() );
	}

	public static IPath getPathFromComponent( IPath path, String tag ) {
		if ( null != path ) {
			return path.removeFileExtension().addFileExtension(tag).addFileExtension(Ooaofooa.MODELS_EXT);
		}
		else {
			return null;
		}
	}

	public static IPath getPathFromComponent( IFile file, String tag ) {
		if ( null != file ) {
			return getPathFromComponent(file.getFullPath(), tag);
		}
		else {
			return null;
		}
	}

	public static IPath getPathFromComponent( String fileName, String tag ) {
		return getPathFromComponent(new Path(fileName), tag);
	}
	
	// get the component file path from the action file path
	public static IPath getComponentPath( IPath path ) {
		if ( null != path ) {
			return path.removeFileExtension().removeFileExtension().addFileExtension(Ooaofooa.MODELS_EXT);
		}
		else {
			return null;
		}
	}

	public static IPath getComponentPath( IFile file ) {
		if ( null != file ) {
			return getComponentPath(file.getFullPath());
		}
		else {
			return null;
		}
	}

	public static IPath getComponentPath( String fileName ) {
		return getComponentPath(new Path(fileName));
	}

}
