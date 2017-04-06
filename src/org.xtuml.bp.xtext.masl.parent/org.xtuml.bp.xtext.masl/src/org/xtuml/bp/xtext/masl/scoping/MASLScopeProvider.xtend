/*
 * generated by Xtext 2.9.2
 */
package org.xtuml.bp.xtext.masl.scoping

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.xtuml.bp.xtext.masl.MASLExtensions
import org.xtuml.bp.xtext.masl.lib.MASLLibraryProvider
import org.xtuml.bp.xtext.masl.masl.behavior.AttributeReferential
import org.xtuml.bp.xtext.masl.masl.behavior.BehaviorPackage
import org.xtuml.bp.xtext.masl.masl.behavior.CharacteristicCall
import org.xtuml.bp.xtext.masl.masl.behavior.CodeBlock
import org.xtuml.bp.xtext.masl.masl.behavior.CreateExpression
import org.xtuml.bp.xtext.masl.masl.behavior.FindExpression
import org.xtuml.bp.xtext.masl.masl.behavior.ForStatement
import org.xtuml.bp.xtext.masl.masl.behavior.GenerateStatement
import org.xtuml.bp.xtext.masl.masl.behavior.NavigateExpression
import org.xtuml.bp.xtext.masl.masl.behavior.SimpleFeatureCall
import org.xtuml.bp.xtext.masl.masl.behavior.SortOrderFeature
import org.xtuml.bp.xtext.masl.masl.behavior.TerminatorActionCall
import org.xtuml.bp.xtext.masl.masl.structure.AbstractActionDefinition
import org.xtuml.bp.xtext.masl.masl.structure.AssocRelationshipDefinition
import org.xtuml.bp.xtext.masl.masl.structure.Characteristic
import org.xtuml.bp.xtext.masl.masl.structure.ObjectDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.ObjectDefinition
import org.xtuml.bp.xtext.masl.masl.structure.Parameter
import org.xtuml.bp.xtext.masl.masl.structure.RegularRelationshipDefinition
import org.xtuml.bp.xtext.masl.masl.structure.RelationshipNavigation
import org.xtuml.bp.xtext.masl.masl.structure.StateDefinition
import org.xtuml.bp.xtext.masl.masl.structure.StructurePackage
import org.xtuml.bp.xtext.masl.masl.structure.SubtypeRelationshipDefinition
import org.xtuml.bp.xtext.masl.masl.structure.TerminatorDefinition
import org.xtuml.bp.xtext.masl.masl.structure.TransitionOption
import org.xtuml.bp.xtext.masl.masl.structure.TransitionRow
import org.xtuml.bp.xtext.masl.typesystem.CollectionType
import org.xtuml.bp.xtext.masl.typesystem.InstanceType
import org.xtuml.bp.xtext.masl.typesystem.MaslType
import org.xtuml.bp.xtext.masl.typesystem.MaslTypeProvider
import org.xtuml.bp.xtext.masl.typesystem.NamedType
import org.xtuml.bp.xtext.masl.typesystem.StructureType
import org.xtuml.bp.xtext.masl.typesystem.TypeOfType
import org.xtuml.bp.xtext.masl.typesystem.TypeParameterResolver

import static org.eclipse.xtext.scoping.Scopes.*

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.xtuml.bp.xtext.masl.masl.structure.ObjectServiceDefinition
import org.xtuml.bp.xtext.masl.masl.structure.RelationshipEnd
import org.eclipse.xtext.resource.EObjectDescription
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.impl.SimpleScope

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class MASLScopeProvider extends AbstractMASLScopeProvider {

	@Inject extension StructurePackage structurePackage
	@Inject extension BehaviorPackage 
	@Inject extension MASLExtensions
	@Inject extension MaslTypeProvider
	@Inject extension ProjectScopeIndexProvider
	@Inject extension TypeParameterResolver

	override getScope(EObject context, EReference reference) {
		switch reference {
			case featureCall_Feature:
				return context.featureScope
			case generateStatement_Event: {
				if(context instanceof GenerateStatement) {
					val contextObject = context.object?:context.containerObject
					if(contextObject != null)	 				
						return createObjectScope(contextObject, [events], super.getScope(context, reference))
				}
			}
			case createArgument_CurrentState: {
				val contextObject = context.getContainerOfType(CreateExpression)?.object
				if(contextObject != null) 
					return createObjectScope(contextObject, [states])				
			}
			case createArgument_Attribute: {
				val contextObject = context.getContainerOfType(CreateExpression)?.object
				if(contextObject != null) 
					return createObjectScope(contextObject, [attributes])				
			}
			case attributeReferential_Attribute: {
				if(context instanceof AttributeReferential) 
					return createObjectScope(context.referredObject, [attributes])
			}
			case transitionRow_Start: {
				if(context instanceof TransitionRow) 
					return createObjectScope(context.getContainerOfType(ObjectDefinition), [states])
			}
			case transitionOption_Event: {
                if(context instanceof TransitionOption) {
                    val contextObject = context?.eventObject
                    if(contextObject != null)
                        return createObjectScope(contextObject, [events]) 
                }
            }
			case transitionOption_EndState: {
				if(context instanceof TransitionOption) 
					return createObjectScope(context.getContainerOfType(ObjectDefinition), [states])		
			}
			case terminatorActionCall_TerminatorAction: {
				if(context instanceof TerminatorActionCall) {
					val receiver = context?.receiver
					if(receiver instanceof SimpleFeatureCall) {
						val feature = receiver.feature
						if(feature instanceof TerminatorDefinition) {
							return scopeFor(feature.services)		
						}						
					}
				} 
			}
			case characteristicCall_Characteristic: {
				if(context instanceof CharacteristicCall) 
					return createCharacteristicScope(context)
			}
			case structurePackage.relationshipNavigation_ObjectOrRole: {
				if(context instanceof RelationshipNavigation) {
					val relationShip = context.relationship
					switch relationShip {
						RegularRelationshipDefinition:
							return scopeFor(#{relationShip.forwards, relationShip.backwards,
								relationShip.forwards.from, relationShip.forwards.to, 
								relationShip.backwards.from, relationShip.backwards.to
							}, new SimpleScope(#[
								qualifiedDescription(relationShip.forwards), 
								qualifiedDescription(relationShip.backwards)
							]))
						AssocRelationshipDefinition:
							return scopeFor(#{relationShip.forwards, relationShip.backwards,
								relationShip.forwards.from, relationShip.forwards.to, 
								relationShip.backwards.from, relationShip.backwards.to,
								relationShip.object
							}, new SimpleScope(#[
								qualifiedDescription(relationShip.forwards), 
								qualifiedDescription(relationShip.backwards)
							]))
						SubtypeRelationshipDefinition:
							return scopeFor(relationShip.subtypes)
							
					}
 				}
			}
		}
		super.getScope(context, reference)
	}
	
	private def qualifiedDescription(RelationshipEnd end) {
		EObjectDescription.create(QualifiedName.create(end.name + '.' + end.to.name), end)
	}
	
	private def <T extends EObject> createObjectScope(ObjectDefinition object, (ObjectDefinition)=>Iterable<? extends T> reference, IScope parentScope) {
		if(object == null || object.eIsProxy)
			return IScope.NULLSCOPE
		val index = object.index
		scopeFor(object
			.getAllSupertypes(index)
			.map[reference.apply(it)]
			.flatten, parentScope)
	}
	
	private def <T extends EObject> createObjectScope(ObjectDefinition object, (ObjectDefinition)=>Iterable<? extends T> reference) {
		createObjectScope(object, reference, IScope.NULLSCOPE)
	}

	private def <T extends EObject> createObjectScope(ObjectDeclaration object, (ObjectDefinition)=>Iterable<? extends T> reference, IScope parentScope) {
		if(object == null || object.eIsProxy)
			return IScope.NULLSCOPE
		val index = object.index
		val definition = object.getObjectDefinition(index)
		scopeFor(definition
			.getAllSupertypes(index)
			.map[reference.apply(it)]
			.flatten, parentScope)
	}

	private def <T extends EObject> createObjectScope(ObjectDeclaration object, (ObjectDefinition)=>Iterable<? extends T> reference) {
		createObjectScope(object, reference, IScope.NULLSCOPE)
	}
	
	private def dispatch IScope getFeatureScope(SortOrderFeature call) {
		call.getContainerOfType(NavigateExpression).maslType.componentType.typeFeatureScope
	}
	
	private def dispatch IScope getFeatureScope(SimpleFeatureCall call) {
		if(call.receiver == null) {
			return call.getLocalSimpleFeatureScope(delegate.getScope(call, featureCall_Feature), false)
		} else {
			val type = call.receiver.maslType
			return getTypeFeatureScope(type)
		}
	}
	
	private def IScope getTypeFeatureScope(MaslType type) {
		switch type {
			InstanceType:
				return type.instance.createObjectScope[attributes + services]
			NamedType: {
				val innerType = type.type
				if (innerType instanceof StructureType)
					return scopeFor(innerType.structureType.components)
			}
			default:
				return IScope.NULLSCOPE
		}
	}

	private def IScope getLocalSimpleFeatureScope(EObject expr, IScope parentScope, boolean isFindExpression_Expression) {
		if(expr == null)
			return IScope.NULLSCOPE
		val parent = expr.eContainer
		switch expr {
			FindExpression: {
				if(!isFindExpression_Expression) {
					val maslType = expr.expression.maslType
					val instance = 
						switch maslType {
							InstanceType: 
								 maslType.instance
							CollectionType case maslType.componentType instanceof InstanceType:
								(maslType.componentType as InstanceType).instance
							default:
								null							
						}
					if (instance != null)
						return instance.createObjectScope([attributes + services], parent.getLocalSimpleFeatureScope(parentScope, false))
				}
			}
			CodeBlock:
				return scopeFor(expr.variables, parent.getLocalSimpleFeatureScope(parentScope, false))
			ForStatement:
				return scopeFor(#[expr.variable], parent.getLocalSimpleFeatureScope(parentScope, false))
			ObjectServiceDefinition:
				return getSimpleFeatureScopeForObjectAction(expr.parameters, expr.getObject, parentScope)
			StateDefinition:
				return getSimpleFeatureScopeForObjectAction(expr.parameters, expr.object, parentScope)
			AbstractActionDefinition:
				return scopeFor(expr.parameters, parentScope)
		}
		return parent.getLocalSimpleFeatureScope(parentScope, expr.eContainmentFeature == findExpression_Expression)
	}
	
	private def getSimpleFeatureScopeForObjectAction(List<Parameter> parameters, ObjectDeclaration context, IScope parentScope) {
		scopeFor(parameters, context.createObjectScope([attributes  + services], parentScope))
	}
	
	private def dispatch IScope getFeatureScope(EObject call) {
		IScope.NULLSCOPE
	}
	
	private def createCharacteristicScope(CharacteristicCall call) {
		val callReceiverType = call.receiver?.maslType
		if(callReceiverType != null) {
			val libResource = call.eResource.resourceSet.getResource(MASLLibraryProvider.MODEL_URI, true)
			val characteristics = libResource.contents.head.getAllContentsOfType(Characteristic)
			val characteristicsForReceiver = characteristics.filter [ c |
				val charReceiverType = if(c.isForValue)
						c.receiverType.maslTypeOfTypeReference
					else
						new TypeOfType(c.receiverType.maslTypeOfTypeReference) 
				return callReceiverType.matchesParameterized(charReceiverType)
			]
			return scopeFor(characteristicsForReceiver)
		} else {
			return IScope.NULLSCOPE
		}
	}
}
